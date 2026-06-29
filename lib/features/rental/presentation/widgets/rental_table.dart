import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../data/models/rental_model.dart';
import '../providers/rental_provider.dart';
import 'rental_form.dart';

class RentalTable extends StatelessWidget {
  const RentalTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RentalProvider>();
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.role == 'admin';

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          "Error: ${provider.error}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final list = provider.paginatedRentals;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text("Tidak ada data rental"),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: [
          const DataColumn(label: Text("Nama Pelanggan")),
          const DataColumn(label: Text("Nama Mobil")),
          const DataColumn(label: Text("Plat Nomor")),
          const DataColumn(label: Text("Tanggal Sewa")),
          const DataColumn(label: Text("Tanggal Kembali")),
          const DataColumn(label: Text("Total Biaya")),
          const DataColumn(label: Text("Status Rental")),
          if (isAdmin) const DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((r) {
          final rentalModel = r as RentalModel;
          final status = r.statusRental.toLowerCase();

          Color statusColor;
          Color statusBg;
          if (status == 'aktif') {
            statusColor = Colors.green;
            statusBg = Colors.green.withValues(alpha: 0.15);
          } else if (status == 'selesai') {
            statusColor = Colors.blue;
            statusBg = Colors.blue.withValues(alpha: 0.15);
          } else {
            statusColor = Colors.red;
            statusBg = Colors.red.withValues(alpha: 0.15);
          }

          return DataRow(
            cells: [
              DataCell(Text(rentalModel.namaPelanggan ?? '-')),
              DataCell(Text(rentalModel.namaMobil ?? '-')),
              DataCell(Text(rentalModel.platNomor ?? '-')),
              DataCell(Text(dateFormat.format(r.tanggalSewa))),
              DataCell(Text(dateFormat.format(r.tanggalKembali))),
              DataCell(Text(currencyFormat.format(r.totalBiaya))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.statusRental.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (isAdmin)
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _showEditDialog(context, provider, rentalModel),
                      ),
                      IconButton(
                        tooltip: "Hapus",
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _confirmDelete(context, provider, r.id),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showEditDialog(BuildContext context, RentalProvider provider, RentalModel rental) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Rental"),
          content: SingleChildScrollView(
            child: RentalForm(rental: rental),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, RentalProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Rental"),
        content: const Text("Apakah Anda yakin ingin menghapus data rental ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deleteRental(id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus: $e")),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
