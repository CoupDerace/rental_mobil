import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

class LaporanPendapatanTable extends StatelessWidget {
  final List<LaporanPendapatan> list;
  const LaporanPendapatanTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data pendapatan"),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text("Tanggal Bayar")),
          DataColumn(label: Text("ID Pembayaran")),
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Nama Pelanggan")),
          DataColumn(label: Text("Metode Pembayaran")),
          DataColumn(label: Text("Jumlah Bayar")),
        ],
        rows: list.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item.tanggalBayar)),
              DataCell(Text(item.idPembayaran)),
              DataCell(Text(item.namaMobil)),
              DataCell(Text(item.namaPelanggan)),
              DataCell(Text(item.metodePembayaran)),
              DataCell(Text(currencyFormat.format(item.jumlahBayar))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
