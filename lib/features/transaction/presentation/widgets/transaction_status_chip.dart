import 'package:flutter/material.dart';

class TransactionStatusChip extends StatelessWidget {
  final String status;

  const TransactionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "Berjalan":
        color = Colors.orange;
        break;

      case "Selesai":
        color = Colors.green;
        break;

      case "Pending":
        color = Colors.blue;
        break;

      default:
        color = Colors.red;
    }

    return Chip(
      backgroundColor: color,
      label: Text(status, style: const TextStyle(color: Colors.white)),
    );
  }
}
