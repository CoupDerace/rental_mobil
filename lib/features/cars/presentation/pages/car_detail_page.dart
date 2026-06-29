import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../domain/entities/car.dart';
import '../widgets/status_badge.dart';

class CarDetailPage extends StatelessWidget {
  const CarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car?;
    final theme = Theme.of(context);

    return AppScaffold(
      title: "Detail Mobil",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: car == null
            ? const Center(child: Text("Data mobil tidak ditemukan"))
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
                        car.namaMobil,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _detailRow("Tipe", car.tipe),
                      _detailRow("Tahun", car.tahun.toString()),
                      _detailRow("Plat Nomor", car.platNomor),
                      _detailRow(
                        "Harga Sewa per Hari",
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(car.hargaSewaPerhari),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Status", style: TextStyle(color: Color(0xFF94A3B8))),
                            StatusBadge(status: car.statusMobil),
                          ],
                        ),
                      ),
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
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
