import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../data/models/pengembalian_model.dart';
import '../providers/pengembalian_provider.dart';
import 'pengembalian_form.dart';

class PengembalianTable extends StatelessWidget {
  const PengembalianTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PengembalianProvider>();
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

    final list = provider.paginatedPengembalians;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data pengembalian"),
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
          const DataColumn(label: Text("Mobil")),
          const DataColumn(label: Text("Tanggal Kembali")),
          const DataColumn(label: Text("Denda")),
          const DataColumn(label: Text("Kondisi Mobil")),
          if (isAdmin) const DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((p) {
          final returnModel = p as PengembalianModel;
          final kondisi = p.kondisiMobil.toLowerCase();

          Color kondisiColor;
          Color kondisiBg;
          if (kondisi == 'baik') {
            kondisiColor = Colors.green;
            kondisiBg = Colors.green.withValues(alpha: 0.15);
          } else if (kondisi == 'lecet ringan') {
            kondisiColor = Colors.orange;
            kondisiBg = Colors.orange.withValues(alpha: 0.15);
          } else if (kondisi == 'rusak ringan') {
            kondisiColor = Colors.redAccent;
            kondisiBg = Colors.redAccent.withValues(alpha: 0.15);
          } else {
            kondisiColor = Colors.red;
            kondisiBg = Colors.red.withValues(alpha: 0.15);
          }

          return DataRow(
            cells: [
              DataCell(Text(returnModel.namaPelanggan ?? '-')),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(returnModel.namaMobil ?? '-'),
                    if (returnModel.platNomor != null)
                      Text(
                        returnModel.platNomor!,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              DataCell(Text(dateFormat.format(p.tanggalKembali))),
              DataCell(Text(currencyFormat.format(p.denda))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kondisiBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p.kondisiMobil.toUpperCase(),
                    style: TextStyle(
                      color: kondisiColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (isAdmin)
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _showEditDialog(context, provider, returnModel),
                      ),
                      IconButton(
                        tooltip: "Hapus",
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _confirmDelete(context, provider, p.id),
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

  void _showEditDialog(BuildContext context, PengembalianProvider provider, PengembalianModel returnModel) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Pengembalian"),
          content: SingleChildScrollView(
            child: PengembalianForm(pengembalian: returnModel),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PengembalianProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pengembalian"),
        content: const Text("Apakah Anda yakin ingin menghapus data pengembalian ini?"),
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
                await provider.deletePengembalian(id);
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
