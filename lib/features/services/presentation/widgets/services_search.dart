import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services_provider.dart';

class ServiceSearch extends StatelessWidget {
  const ServiceSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<ServicesProvider>().searchController,
      decoration: const InputDecoration(
        hintText: 'Cari servis...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (_) {
        context.read<ServicesProvider>().refresh();
      },
    );
  }
}
