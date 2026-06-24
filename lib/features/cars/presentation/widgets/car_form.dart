import 'package:flutter/material.dart';

class CarForm extends StatelessWidget {
  const CarForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: "Plat Nomor")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Merk")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Tipe")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Tahun")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Harga Sewa")),
      ],
    );
  }
}
