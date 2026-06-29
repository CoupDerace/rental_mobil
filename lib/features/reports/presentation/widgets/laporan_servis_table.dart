import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

class LaporanServisTable extends StatelessWidget {
  final List<LaporanServis> list;
  const LaporanServisTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
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
          DataColumn(label: Text("Status Servis")),
          DataColumn(label: Text("Keterangan")),
        ],
        rows: list.map((item) {
          Color statusColor;
          switch (item.statusServis.toLowerCase()) {
            case 'proses':
              statusColor = Colors.orange;
              break;
            case 'selesai':
              statusColor = Colors.green;
              break;
            default:
              statusColor = Colors.grey;
          }

          return DataRow(
            cells: [
              DataCell(Text(item.namaMobil)),
              DataCell(Text(item.platNomor)),
              DataCell(Text(dateFormat.format(item.tanggalServis))),
              DataCell(Text(item.jenisServis)),
              DataCell(Text(currencyFormat.format(item.biayaServis))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.statusServis.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ),
              DataCell(Text(item.keterangan ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
