import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String name;
  final String role;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const AppDrawer({
    super.key,
    required this.name,
    required this.role,
    this.selectedIndex = 0,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(role),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _item(context, 0, Icons.dashboard, "Dashboard"),

                _item(context, 1, Icons.people, "Users"),

                _item(context, 2, Icons.directions_car, "Mobil"),

                _item(context, 3, Icons.person_pin, "Driver"),

                _item(context, 4, Icons.receipt_long, "Transaksi"),

                _item(context, 5, Icons.bar_chart, "Laporan"),

                _item(context, 6, Icons.settings, "Pengaturan"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, int index, IconData icon, String title) {
    return ListTile(
      selected: selectedIndex == index,
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onSelected?.call(index),
    );
  }
}
