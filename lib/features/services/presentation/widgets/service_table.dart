import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/service_model.dart';
import '../providers/service_provider.dart';
import 'service_form.dart';

class ServiceTable extends StatelessWidget {
  const ServiceTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

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

    final list = provider.paginatedServices;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data servis"),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Plat Nomor")),
          DataColumn(label: Text("Tanggal Servis")),
          DataColumn(label: Text("Jenis Servis")),
          DataColumn(label: Text("Biaya Servis")),
          DataColumn(label: Text("Keterangan")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((s) {
          final serviceModel = s as ServiceModel;

          return DataRow(
            cells: [
              DataCell(Text(serviceModel.namaMobil ?? '-')),
              DataCell(Text(serviceModel.platNomor ?? '-')),
              DataCell(Text(dateFormat.format(s.tanggalServis))),
              DataCell(Text(s.jenisServis)),
              DataCell(Text(currencyFormat.format(s.biayaServis))),
              DataCell(Text(s.keterangan ?? '-')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.statusServis.toLowerCase() == 'proses'
                        ? Colors.blue.withValues(alpha: 0.15)
                        : Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        s.statusServis.toLowerCase() == 'proses'
                            ? Icons.build_circle
                            : Icons.check_circle,
                        size: 12,
                        color: s.statusServis.toLowerCase() == 'proses'
                            ? Colors.blue
                            : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        s.statusServis.toLowerCase() == 'proses' ? 'Proses' : 'Selesai',
                        style: TextStyle(
                          color: s.statusServis.toLowerCase() == 'proses'
                              ? Colors.blue
                              : Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      tooltip: "Edit",
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () => _showEditDialog(context, provider, serviceModel),
                    ),
                    IconButton(
                      tooltip: "Hapus",
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _confirmDelete(context, provider, s.id),
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

  void _showEditDialog(BuildContext context, ServiceProvider provider, ServiceModel service) async {
    await provider.fetchCars();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Servis"),
          content: SingleChildScrollView(
            child: ServiceForm(service: service),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ServiceProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Servis"),
        content: const Text("Apakah Anda yakin ingin menghapus data servis ini?"),
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
                await provider.deleteService(id);
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
