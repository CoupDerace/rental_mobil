import 'package:flutter/material.dart';

class ReportSummary extends StatelessWidget {
  const ReportSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: Text("Total Pendapatan"),
              trailing: Text("Rp 24.500.000"),
            ),

            Divider(),

            ListTile(title: Text("Total Transaksi"), trailing: Text("142")),

            Divider(),

            ListTile(title: Text("Total Mobil"), trailing: Text("35")),
          ],
        ),
      ),
    );
  }
}
