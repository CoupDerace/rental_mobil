import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import '../../../../core/components/organism/app_scaffold.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  bool _loading = true;
  String? _error;

  double _totalPendapatan = 0;
  int _totalArmada = 0;
  int _totalTransaksi = 0;
  int _totalPelanggan = 0;

  List<Map<String, dynamic>> _recentRentals = [];
  List<Map<String, dynamic>> _pendapatanList = [];
  List<Map<String, dynamic>> _top5Mobil = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1. Fetch dashboard_summary view
      final summaryRes = await SupabaseService.from('dashboard_summary').select().single();
      final double pendapatan = (summaryRes['total_pendapatan'] as num?)?.toDouble() ?? 0.0;
      final int totalMobil = (summaryRes['total_mobil'] as num?)?.toInt() ?? 0;
      final int totalRental = (summaryRes['total_rental'] as num?)?.toInt() ?? 0;
      final int totalPelanggan = (summaryRes['total_pelanggan'] as num?)?.toInt() ?? 0;

      // 2. Fetch Recent Rentals from laporan_transaksi_rental
      final recentRentalRes = await SupabaseService.from('laporan_transaksi_rental')
          .select()
          .order('created_at', ascending: false)
          .limit(5);

      // 3. Fetch Pendapatan Info from view_pendapatan
      final pendapatanRes = await SupabaseService.from('view_pendapatan')
          .select()
          .order('tanggal', ascending: false)
          .limit(5);

      // 4. Fetch Top Mobil from laporan_mobil_populer
      final topMobilRes = await SupabaseService.from('laporan_mobil_populer')
          .select()
          .order('total_disewa', ascending: false)
          .limit(5);

      if (mounted) {
        setState(() {
          _totalPendapatan = pendapatan;
          _totalArmada = totalMobil;
          _totalTransaksi = totalRental;
          _totalPelanggan = totalPelanggan;
          _recentRentals = List<Map<String, dynamic>>.from(recentRentalRes);
          _pendapatanList = List<Map<String, dynamic>>.from(pendapatanRes);
          _top5Mobil = List<Map<String, dynamic>>.from(topMobilRes);
          _loading = false;
        });
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
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppScaffold(
      title: "Dashboard Owner",
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text("Error: $_error", style: const TextStyle(color: Colors.red)),
                    ),

                  // Section 1: Summary Cards Grid (150px height, 16px gap)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: (MediaQuery.of(context).size.width / 2) / 150,
                    children: [
                      _card("Pendapatan", currencyFormat.format(_totalPendapatan), Icons.payments, const Color(0xFF22C55E)),
                      _card("Total Armada", "$_totalArmada Mobil", Icons.directions_car, const Color(0xFFFF7A1A)),
                      _card("Total Transaksi", "$_totalTransaksi Rental", Icons.receipt_long, const Color(0xFFF59E0B)),
                      _card("Total Pelanggan", "$_totalPelanggan User", Icons.people, const Color(0xFFEF4444)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 2: Recent Rental Table
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
                            "Transaksi Rental Terbaru",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_recentRentals.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text("Belum ada data transaksi rental", style: TextStyle(color: Color(0xFF94A3B8)))),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
                                columns: const [
                                  DataColumn(label: Text("Pelanggan", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Mobil", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Tanggal Sewa", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Total Biaya", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Status", style: TextStyle(color: Colors.white))),
                                ],
                                rows: _recentRentals.map((item) {
                                  final tanggalSewa = item['tanggal_sewa'] != null ? DateTime.parse(item['tanggal_sewa']) : DateTime.now();
                                  final double totalBiaya = (item['total_biaya'] as num?)?.toDouble() ?? 0.0;
                                  final status = item['status_rental']?.toString().toUpperCase() ?? 'AKTIF';
                                  
                                  Color statusColor = Colors.blue;
                                  if (status == 'SELESAI') statusColor = Colors.green;
                                  if (status == 'DIBATALKAN') statusColor = Colors.red;

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['nama_pelanggan']?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(item['nama_mobil']?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(dateFormat.format(tanggalSewa), style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(currencyFormat.format(totalBiaya), style: const TextStyle(color: Colors.white))),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 3: Pendapatan Information (Simple list table of daily income)
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
                            "Informasi Pendapatan Harian",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_pendapatanList.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text("Belum ada data pendapatan", style: TextStyle(color: Color(0xFF94A3B8)))),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
                                columns: const [
                                  DataColumn(label: Text("Tanggal", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Total Pendapatan", style: TextStyle(color: Colors.white))),
                                ],
                                rows: _pendapatanList.map((item) {
                                  final double total = (item['total'] as num?)?.toDouble() ?? 0.0;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['tanggal']?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(currencyFormat.format(total), style: const TextStyle(color: Colors.white))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 4: Popular Mobil Table (Top 5 Mobil Paling Laris)
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
                            "Top 5 Mobil Paling Laris",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_top5Mobil.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text("Belum ada data mobil populer", style: TextStyle(color: Color(0xFF94A3B8)))),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
                                columns: const [
                                  DataColumn(label: Text("Nama Mobil", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Plat Nomor", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Total Sewa", style: TextStyle(color: Colors.white))),
                                  DataColumn(label: Text("Total Pendapatan", style: TextStyle(color: Colors.white))),
                                ],
                                rows: _top5Mobil.map((item) {
                                  final int disewaCount = (item['total_disewa'] as num?)?.toInt() ?? 0;
                                  final double totalPendapatan = (item['total_pendapatan'] as num?)?.toDouble() ?? 0.0;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['nama_mobil']?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(item['plat_nomor']?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
                                      DataCell(Text("$disewaCount Kali", style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(currencyFormat.format(totalPendapatan), style: const TextStyle(color: Colors.white))),
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
