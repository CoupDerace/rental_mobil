import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Edit Profil"),
          trailing: Icon(Icons.chevron_right),
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Ubah Password"),
          trailing: Icon(Icons.chevron_right),
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.info),
          title: Text("Tentang Aplikasi"),
          trailing: Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
