import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

class LaporanSummaryCard extends StatelessWidget {
  final DashboardSummary summary;
  const LaporanSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      children: [
        _buildCard(
          context,
          title: "Total Pendapatan",
          value: currencyFormat.format(summary.totalPendapatan),
          icon: Icons.payments,
          color: Colors.green,
        ),
        _buildCard(
          context,
          title: "Total Rental",
          value: "${summary.totalRental} Transaksi",
          icon: Icons.receipt_long,
          color: Colors.blue,
        ),
        _buildCard(
          context,
          title: "Total Pelanggan",
          value: "${summary.totalPelanggan} Orang",
          icon: Icons.people,
          color: Colors.orange,
        ),
        _buildCard(
          context,
          title: "Total Armada Mobil",
          value: "${summary.totalMobil} Mobil",
          icon: Icons.directions_car,
          color: Colors.purple,
        ),
        _buildCard(
          context,
          title: "Mobil Tersedia",
          value: "${summary.mobilTersedia} Mobil",
          icon: Icons.check_circle,
          color: Colors.teal,
        ),
        _buildCard(
          context,
          title: "Mobil Sedang Disewa",
          value: "${summary.mobilDisewa} Mobil",
          icon: Icons.time_to_leave,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
