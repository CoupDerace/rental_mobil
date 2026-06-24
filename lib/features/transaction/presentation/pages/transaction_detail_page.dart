import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Detail Transaksi",
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(title: Text("Customer"), subtitle: Text("Ahmad Fauzi")),

          Divider(),

          ListTile(title: Text("Mobil"), subtitle: Text("Toyota Avanza")),

          Divider(),

          ListTile(title: Text("Driver"), subtitle: Text("Budi")),

          Divider(),

          ListTile(title: Text("Status"), subtitle: Text("Berjalan")),

          Divider(),

          ListTile(title: Text("Total"), subtitle: Text("Rp 800.000")),
        ],
      ),
    );
  }
}
