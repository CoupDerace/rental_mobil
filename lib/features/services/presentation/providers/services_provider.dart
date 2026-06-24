import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'vehicle': 'Toyota Avanza',
      'plate': 'B 1234 ABC',
      'service': 'Ganti Oli',
      'workshop': 'Auto Service',
      'date': '20 Juni 2026',
      'cost': 450000,
      'status': 'Selesai',
    },
    {
      'id': 2,
      'vehicle': 'Honda Brio',
      'plate': 'B 5678 XYZ',
      'service': 'Tune Up',
      'workshop': 'Honda Care',
      'date': '22 Juni 2026',
      'cost': 750000,
      'status': 'Proses',
    },
  ];

  List<Map<String, dynamic>> get services => _services;

  List<Map<String, dynamic>> get filteredServices {
    if (searchController.text.isEmpty) {
      return services;
    }

    final keyword = searchController.text.toLowerCase();

    return services.where((service) {
      return service['vehicle'].toString().toLowerCase().contains(keyword) ||
          service['plate'].toString().toLowerCase().contains(keyword) ||
          service['service'].toString().toLowerCase().contains(keyword);
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
