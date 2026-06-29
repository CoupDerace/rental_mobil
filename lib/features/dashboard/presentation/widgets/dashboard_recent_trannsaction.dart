import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/dashboard_provider.dart';

class DashboardRecentTransaction extends StatelessWidget {
  const DashboardRecentTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final activities = provider.recentActivities;
    final payments = provider.recentPayments;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table 1: Recent Rental Table
        Text(
          'Recent Rental',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: activities.isEmpty
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada data rental terbaru'),
                  ))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Pelanggan")),
                        DataColumn(label: Text("Mobil")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Total Biaya")),
                      ],
                      rows: activities.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.customerName)),
                            DataCell(Text(item.carName)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(_formatCurrency(item.total))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 32),

        // Table 2: Recent Payment Table
        Text(
          'Recent Payment',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: payments.isEmpty
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada data pembayaran terbaru'),
                  ))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Pelanggan")),
                        DataColumn(label: Text("Mobil")),
                        DataColumn(label: Text("Jumlah Bayar")),
                        DataColumn(label: Text("Metode")),
                        DataColumn(label: Text("Tanggal")),
                      ],
                      rows: payments.map((item) {
                        final double amount = (item['jumlah_bayar'] as num?)?.toDouble() ?? 0.0;
                        final dateStr = item['tanggal_bayar']?.toString() ?? '-';
                        final shortDate = dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
                        return DataRow(
                          cells: [
                            DataCell(Text(item['nama_pelanggan']?.toString() ?? '')),
                            DataCell(Text(item['nama_mobil']?.toString() ?? '')),
                            DataCell(Text(_formatCurrency(amount))),
                            DataCell(Text(item['metode_pembayaran']?.toString() ?? '')),
                            DataCell(Text(shortDate)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}
