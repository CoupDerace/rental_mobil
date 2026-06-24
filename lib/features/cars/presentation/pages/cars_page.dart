import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/cars/presentation/providers/car_provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/car_list.dart';
import '../widgets/car_search.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarsProvider(),
      child: AppScaffold(
        title: "Data Mobil",
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [CarSearch(), SizedBox(height: 20), CarList()],
        ),
      ),
    );
  }
}
