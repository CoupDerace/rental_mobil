import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import 'dashboard_stat_card.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),

      shrinkWrap: true,

      crossAxisCount: 2,

      crossAxisSpacing: 16,

      mainAxisSpacing: 16,

      childAspectRatio: 1.5,

      children: [
        DashboardStatCard(
          icon: Icons.directions_car,
          title: "Mobil",
          value: provider.totalCars.toString(),
        ),

        DashboardStatCard(
          icon: Icons.person,
          title: "Driver",
          value: provider.totalDrivers.toString(),
        ),

        DashboardStatCard(
          icon: Icons.people,
          title: "Customer",
          value: provider.totalCustomers.toString(),
        ),

        DashboardStatCard(
          icon: Icons.receipt_long,
          title: "Transaksi",
          value: provider.totalTransactions.toString(),
        ),
      ],
    );
  }
}
