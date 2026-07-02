import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../pengembalian/domain/entities/pengembalian.dart';

class LaporanPengembalianTable extends StatelessWidget {
  final List<Pengembalian> list;
  const LaporanPengembalianTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
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
        columns: const [
          DataColumn(label: Text("Nama Pelanggan")),
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Plat Nomor")),
          DataColumn(label: Text("Tanggal Sewa")),
          DataColumn(label: Text("Tanggal Estimasi")),
          DataColumn(label: Text("Tanggal Pengembalian")),
          DataColumn(label: Text("Biaya Rental")),
          DataColumn(label: Text("Denda")),
          DataColumn(label: Text("Total Bayar")),
          DataColumn(label: Text("Kondisi Mobil")),
          DataColumn(label: Text("Status Rental")),
        ],
        rows: list.map((item) {
          Color statusColor;
          final status = item.statusRental ?? '';
          switch (status.toLowerCase()) {
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
              DataCell(Text(item.namaPelanggan ?? '')),
              DataCell(Text(item.namaMobil ?? '')),
              DataCell(Text(item.platNomor ?? '')),
              DataCell(Text(item.tanggalSewa != null ? dateFormat.format(item.tanggalSewa!) : '-')),
              DataCell(Text(item.tanggalEstimasi != null ? dateFormat.format(item.tanggalEstimasi!) : '-')),
              DataCell(Text(item.tanggalPengembalian != null ? dateFormat.format(item.tanggalPengembalian!) : '-')),
              DataCell(Text(currencyFormat.format(item.totalBiaya ?? 0.0))),
              DataCell(Text(currencyFormat.format(item.denda))),
              DataCell(Text(currencyFormat.format(item.totalBayar ?? 0.0))),
              DataCell(Text(item.kondisiMobil)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
