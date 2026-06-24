import 'package:flutter/material.dart';

class ServiceForm extends StatelessWidget {
  const ServiceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Mobil')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Jenis Servis')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Nama Bengkel')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Biaya')),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: 'Tanggal Servis')),
      ],
    );
  }
}
