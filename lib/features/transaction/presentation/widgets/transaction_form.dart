import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: "Nama Customer")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Mobil")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Karyawan / PIC (Opsional)")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Tanggal Mulai")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Tanggal Selesai")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Harga Sewa")),
      ],
    );
  }
}
