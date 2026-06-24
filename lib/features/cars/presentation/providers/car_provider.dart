import 'package:flutter/material.dart';

class CarsProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _cars = [
    {
      'id': 1,
      'plate': 'B 1234 ABC',
      'brand': 'Toyota',
      'model': 'Avanza',
      'year': 2023,
      'price': 350000,
      'status': 'Tersedia',
    },
    {
      'id': 2,
      'plate': 'B 4321 XYZ',
      'brand': 'Honda',
      'model': 'Brio',
      'year': 2022,
      'price': 300000,
      'status': 'Disewa',
    },
  ];

  List<Map<String, dynamic>> get cars => _cars;

  List<Map<String, dynamic>> get filteredCars {
    if (searchController.text.isEmpty) {
      return cars;
    }

    return cars.where((car) {
      final keyword = searchController.text.toLowerCase();

      return car['plate'].toString().toLowerCase().contains(keyword) ||
          car['brand'].toString().toLowerCase().contains(keyword) ||
          car['model'].toString().toLowerCase().contains(keyword);
    }).toList();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
