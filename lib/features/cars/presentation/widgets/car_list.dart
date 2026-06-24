import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/cars/presentation/providers/car_provider.dart';

import 'car_card.dart';

class CarList extends StatelessWidget {
  const CarList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarsProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.filteredCars.length,
      itemBuilder: (_, index) {
        return CarCard(car: provider.filteredCars[index]);
      },
    );
  }
}
