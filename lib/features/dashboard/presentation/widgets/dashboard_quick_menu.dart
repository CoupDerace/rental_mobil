import 'package:flutter/material.dart';

class DashboardQuickMenu extends StatelessWidget {
  const DashboardQuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = [
      ("Mobil", Icons.directions_car),
      ("Pelanggan", Icons.people),
      ("Rental", Icons.assignment),
      ("Pembayaran", Icons.payments),
      ("Pengembalian", Icons.keyboard_return),
      ("Servis", Icons.build),
      ("Laporan", Icons.bar_chart),
      ("User", Icons.admin_panel_settings),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menu.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (_, index) {
        return Column(
          children: [
            CircleAvatar(child: Icon(menu[index].$2)),
            const SizedBox(height: 8),
            Text(menu[index].$1),
          ],
        );
      },
    );
  }
}
