import 'package:flutter/material.dart';

class DriversProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _drivers = [
    {
      'id': 1,
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'license': 'SIM A',
      'status': 'Aktif',
    },
    {
      'id': 2,
      'name': 'Andi Saputra',
      'phone': '081987654321',
      'license': 'SIM A',
      'status': 'Sedang Bertugas',
    },
  ];

  List<Map<String, dynamic>> get drivers => _drivers;

  List<Map<String, dynamic>> get filteredDrivers {
    if (searchController.text.isEmpty) {
      return drivers;
    }

    final keyword = searchController.text.toLowerCase();

    return drivers.where((driver) {
      return driver['name'].toString().toLowerCase().contains(keyword) ||
          driver['phone'].toString().toLowerCase().contains(keyword);
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
