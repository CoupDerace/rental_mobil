import 'package:flutter/material.dart';

class DashboardQuickMenu extends StatelessWidget {
  const DashboardQuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = [
      ("Mobil", Icons.directions_car),
      ("Driver", Icons.person),
      ("User", Icons.people),
      ("Laporan", Icons.bar_chart),
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
