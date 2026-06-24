import 'package:flutter/material.dart';

class DashboardRecentTransaction extends StatelessWidget {
  const DashboardRecentTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (_, index) {
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text("Transaksi #${index + 1}"),
            subtitle: const Text("Sedang Berjalan"),
            trailing: const Text("Rp 500.000"),
          );
        },
      ),
    );
  }
}
