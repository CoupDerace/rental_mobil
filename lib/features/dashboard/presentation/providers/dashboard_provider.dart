import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int _selectedMenu = 0;

  int get selectedMenu => _selectedMenu;

  void changeMenu(int index) {
    _selectedMenu = index;
    notifyListeners();
  }

  int totalCars = 24;
  int totalDrivers = 8;
  int totalCustomers = 126;
  int totalTransactions = 51;

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    notifyListeners();
  }
}
