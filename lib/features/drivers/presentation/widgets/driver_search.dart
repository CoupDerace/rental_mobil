import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driver_provider.dart';

class DriverSearch extends StatelessWidget {
  const DriverSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<DriversProvider>().searchController,
      decoration: const InputDecoration(
        hintText: 'Cari driver...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (_) {
        context.read<DriversProvider>().refresh();
      },
    );
  }
}
