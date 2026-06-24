import 'package:flutter/material.dart';

class DriverForm extends StatelessWidget {
  const DriverForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Nama Driver')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Nomor HP')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Nomor SIM')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Alamat')),
      ],
    );
  }
}
