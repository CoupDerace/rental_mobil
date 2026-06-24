import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: "Nama")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Email")),

        SizedBox(height: 16),

        TextField(decoration: InputDecoration(labelText: "Nomor HP")),
      ],
    );
  }
}
