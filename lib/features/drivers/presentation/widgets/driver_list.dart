import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driver_provider.dart';
import 'driver_card.dart';

class DriverList extends StatelessWidget {
  const DriverList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriversProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.filteredDrivers.length,
      itemBuilder: (_, index) {
        return DriverCard(driver: provider.filteredDrivers[index]);
      },
    );
  }
}
