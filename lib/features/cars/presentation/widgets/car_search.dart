import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/cars/presentation/providers/car_provider.dart';


class CarSearch extends StatelessWidget {
  const CarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<CarsProvider>().searchController,
      decoration: const InputDecoration(
        hintText: "Cari mobil...",
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (_) {
        context.read<CarsProvider>().refresh();
      },
    );
  }
}
