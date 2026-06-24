import 'package:flutter/material.dart';

import 'transaction_status_chip.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
        title: Text(transaction["customer"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction["car"]),

            Text(transaction["driver"]),

            Text("${transaction["startDate"]} - ${transaction["endDate"]}"),
          ],
        ),
        trailing: TransactionStatusChip(status: transaction["status"]),
      ),
    );
  }
}
