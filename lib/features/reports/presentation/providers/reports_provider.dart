import 'package:flutter/material.dart';

class ReportsProvider extends ChangeNotifier {
  String _filter = "Bulanan";

  String get filter => _filter;

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  final List<Map<String, dynamic>> reports = [
    {"title": "Pendapatan", "value": "Rp 24.500.000"},
    {"title": "Total Transaksi", "value": "142"},
    {"title": "Mobil Disewa", "value": "35"},
    {"title": "Driver Bertugas", "value": "11"},
  ];
}
