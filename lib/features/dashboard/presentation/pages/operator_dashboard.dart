import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../core/components/atoms/notification_bell.dart';

class OperatorDashboard extends StatefulWidget {
  const OperatorDashboard({super.key});

  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard> {
  bool _loading = true;
  String? _error;

  int _servisHariIni = 0;
  int _servisBulanIni = 0;
  List<Map<String, dynamic>> _recentServis = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final todayStr = DateTime.now().toString().substring(0, 10);
      final currentMonthStr = todayStr.substring(0, 7);

      // Query all services to dynamically inspect column names
      final servisList = await SupabaseService.from('servis')
          .select('*, mobil(nama_mobil)');

      if (servisList.isNotEmpty) {
        final Map<String, dynamic> firstRow = servisList.first;
        final dateKey = firstRow.containsKey('tanggal_servis') ? 'tanggal_servis' : 'tanggal_masuk';
        final serviceKey = firstRow.containsKey('jenis_servis') ? 'jenis_servis' : 'jenis_service';
        final costKey = firstRow.containsKey('biaya_servis') ? 'biaya_servis' : 'biaya';

        int todayCount = 0;
        int monthCount = 0;

        for (var row in servisList) {
          final dateVal = row[dateKey]?.toString() ?? '';
          if (dateVal.startsWith(todayStr)) {
            todayCount++;
          }
          if (dateVal.startsWith(currentMonthStr)) {
            monthCount++;
          }
        }

        // Sort by date key DESC and limit 5
        final sortedList = List<Map<String, dynamic>>.from(servisList)
          ..sort((a, b) {
            final aDate = a[dateKey]?.toString() ?? '';
            final bDate = b[dateKey]?.toString() ?? '';
            return bDate.compareTo(aDate);
          });

        final top5 = sortedList.take(5).map((e) {
          final mobil = e['mobil'] as Map<String, dynamic>?;
          return {
            'nama_mobil': mobil?['nama_mobil'] ?? 'Mobil',
            'tanggal_servis': e[dateKey]?.toString() ?? '',
            'jenis_servis': e[serviceKey]?.toString() ?? '',
            'biaya_servis': (e[costKey] as num?)?.toDouble() ?? 0.0,
            'keterangan': e['keterangan']?.toString() ?? '',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _servisHariIni = todayCount;
            _servisBulanIni = monthCount;
            _recentServis = top5;
            _loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: "Dashboard Operator",
      actions: const [
        NotificationBell(),
      ],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text("Error: $_error", style: const TextStyle(color: Colors.red)),
                    ),

                  // Cards (150px height, 16px gap)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: (MediaQuery.of(context).size.width / 2) / 150,
                    children: [
                      _card("Servis Hari Ini", "$_servisHariIni Servis", Icons.build, const Color(0xFFFF7A1A)),
                      _card("Servis Bulan Ini", "$_servisBulanIni Servis", Icons.build_circle, const Color(0xFF22C55E)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent Servis Table
                  Card(
                    color: const Color(0xFF1E2A44),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Servis Table",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_recentServis.isEmpty)
                            const Center(child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Belum ada data servis terbaru", style: TextStyle(color: Color(0xFF94A3B8))),
                            ))
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text("Mobil", style: TextStyle(color: Color(0xFF94A3B8)))),
                                  DataColumn(label: Text("Tanggal", style: TextStyle(color: Color(0xFF94A3B8)))),
                                  DataColumn(label: Text("Jenis Servis", style: TextStyle(color: Color(0xFF94A3B8)))),
                                  DataColumn(label: Text("Biaya", style: TextStyle(color: Color(0xFF94A3B8)))),
                                  DataColumn(label: Text("Keterangan", style: TextStyle(color: Color(0xFF94A3B8)))),
                                ],
                                rows: _recentServis.map((item) {
                                  final double biaya = (item['biaya_servis'] as num?)?.toDouble() ?? 0.0;
                                  final currencyFormat = NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  );
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['nama_mobil'], style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(item['tanggal_servis'], style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(item['jenis_servis'], style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(currencyFormat.format(biaya), style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(item['keterangan'], style: const TextStyle(color: Colors.white))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _card(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A44),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
