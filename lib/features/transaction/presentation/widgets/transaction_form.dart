import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Nama Customer"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
        ),

        const SizedBox(height: 16),

        const TextField(decoration: InputDecoration(labelText: "Mobil")),

        const SizedBox(height: 16),

        const TextField(decoration: InputDecoration(labelText: "Karyawan / PIC (Opsional)")),

        const SizedBox(height: 16),

        const TextField(decoration: InputDecoration(labelText: "Tanggal Mulai")),

        const SizedBox(height: 16),

        const TextField(decoration: InputDecoration(labelText: "Tanggal Selesai")),

        const SizedBox(height: 16),

        const TextField(decoration: InputDecoration(labelText: "Harga Sewa")),
      ],
    );
  }
}
