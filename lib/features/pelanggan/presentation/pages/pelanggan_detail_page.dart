import 'package:flutter/material.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../domain/entities/pelanggan.dart';

class PelangganDetailPage extends StatelessWidget {
  const PelangganDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pelanggan = ModalRoute.of(context)?.settings.arguments as Pelanggan?;
    final theme = Theme.of(context);

    return AppScaffold(
      title: "Detail Pelanggan",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: pelanggan == null
            ? const Center(child: Text("Data pelanggan tidak ditemukan"))
            : Card(
                color: const Color(0xFF1E2A44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pelanggan.nama,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _detailRow("Nomor HP", pelanggan.noHp),
                      _detailRow("Alamat", pelanggan.alamat ?? '-'),
                      _detailRow("Jenis Identitas", pelanggan.jenisIdentitas),
                      _detailRow("No Identitas", pelanggan.noIdentitas),
                      _detailRow("Terdaftar", _formatDate(pelanggan.createdAt)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8))),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
