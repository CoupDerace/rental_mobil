import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

class LaporanMobilTable extends StatelessWidget {
  final List<LaporanMobilPopuler> list;
  const LaporanMobilTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data mobil populer"),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text("Nama Mobil")),
          DataColumn(label: Text("Plat Nomor")),
          DataColumn(label: Text("Total Disewa")),
          DataColumn(label: Text("Total Pendapatan")),
        ],
        rows: list.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item.namaMobil)),
              DataCell(Text(item.platNomor)),
              DataCell(Text("${item.totalDisewa} Kali")),
              DataCell(Text(currencyFormat.format(item.totalPendapatan))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
