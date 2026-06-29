import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rental_mobil/features/cars/presentation/providers/car_provider.dart';

import 'car_form.dart';
import 'status_badge.dart';

class CarList extends StatelessWidget {
  const CarList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarsProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text("Error: ${provider.error}", style: const TextStyle(color: Colors.red)));
    }

    final cars = provider.filteredCars;

    if (cars.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20),
        child: Text("Tidak ada data mobil"),
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Tipe")),
          DataColumn(label: Text("Tahun")),
          DataColumn(label: Text("Plat Nomor")),
          DataColumn(label: Text("Harga")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Aksi")),
        ],
        rows: cars.map((car) {
          return DataRow(
            cells: [
              DataCell(Text(car.namaMobil)),
              DataCell(Text(car.tipe)),
              DataCell(Text(car.tahun.toString())),
              DataCell(Text(car.platNomor)),
              DataCell(
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(car.hargaSewaPerhari),
                ),
              ),
              DataCell(StatusBadge(status: car.statusMobil)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () => _showEditDialog(context, provider, {
                        'id': car.id,
                        'nama_mobil': car.namaMobil,
                        'tipe': car.tipe,
                        'tahun': car.tahun,
                        'plat_nomor': car.platNomor,
                        'harga_sewa_perhari': car.hargaSewaPerhari,
                        'status_mobil': car.statusMobil,
                      }),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _confirmDelete(context, provider, car.id),
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

  void _showEditDialog(BuildContext context, CarsProvider provider, Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Mobil"),
          content: SingleChildScrollView(
            child: CarForm(car: car),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CarsProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Mobil"),
        content: const Text("Apakah Anda yakin ingin menghapus data mobil ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deleteCar(id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus: $e")),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
