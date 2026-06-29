import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rental_mobil/app/routes/routes.dart';

import 'dashboard_card.dart';
import '../providers/dashboard_provider.dart';

class DashboardGrid extends StatelessWidget {
  final bool isOwner;
  const DashboardGrid({super.key, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final d = provider.dashboard;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 1024 ? 3 : 2;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: count,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            DashboardCard(
              icon: Icons.directions_car,
              title: 'Total Mobil',
              value: '${d?.totalMobil ?? 0}',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRoutes.cars),
            ),
            DashboardCard(
              icon: Icons.check_circle_outline,
              title: 'Mobil Tersedia',
              value: '${d?.mobilTersedia ?? 0}',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, AppRoutes.cars),
            ),
            DashboardCard(
              icon: Icons.car_rental,
              title: 'Mobil Disewa',
              value: '${d?.mobilDisewa ?? 0}',
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, AppRoutes.cars),
            ),
            DashboardCard(
              icon: Icons.receipt_long,
              title: 'Total Rental',
              value: '${d?.totalRental ?? 0}',
              color: Colors.amber,
              onTap: () => Navigator.pushNamed(context, AppRoutes.transactions),
            ),
            DashboardCard(
              icon: Icons.people,
              title: 'Total Pelanggan',
              value: '${d?.totalPelanggan ?? 0}',
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(context, AppRoutes.pelanggan),
            ),
            DashboardCard(
              icon: Icons.attach_money,
              title: 'Total Pendapatan',
              value: currencyFormat.format(d?.totalPendapatan ?? 0),
              color: Colors.teal,
              onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
            ),
          ],
        );
      },
    );
  }
}
