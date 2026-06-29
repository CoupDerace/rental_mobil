import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

class LaporanRentalTable extends StatelessWidget {
  final List<LaporanTransaksiRental> list;
  const LaporanRentalTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data transaksi rental"),
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
          DataColumn(label: Text("ID Rental")),
          DataColumn(label: Text("Nama Pelanggan")),
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Plat Nomor")),
          DataColumn(label: Text("Tanggal Sewa")),
          DataColumn(label: Text("Tanggal Kembali")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Total Biaya")),
        ],
        rows: list.map((item) {
          Color statusColor;
          switch (item.statusRental.toLowerCase()) {
            case 'aktif':
              statusColor = Colors.blue;
              break;
            case 'selesai':
              statusColor = Colors.green;
              break;
            case 'dibatalkan':
              statusColor = Colors.red;
              break;
            default:
              statusColor = Colors.grey;
          }

          return DataRow(
            cells: [
              DataCell(Text(item.idRental)),
              DataCell(Text(item.namaPelanggan)),
              DataCell(Text(item.namaMobil)),
              DataCell(Text(item.platNomor)),
              DataCell(Text(dateFormat.format(item.tanggalSewa))),
              DataCell(Text(dateFormat.format(item.tanggalKembali))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.statusRental.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ),
              DataCell(Text(currencyFormat.format(item.totalBiaya))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
