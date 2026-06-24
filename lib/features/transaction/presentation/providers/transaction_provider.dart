import 'package:flutter/material.dart';

class TransactionsProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _transactions = [
    {
      "id": 1,
      "customer": "Ahmad Fauzi",
      "car": "Toyota Avanza",
      "driver": "Budi",
      "startDate": "20 Juni 2026",
      "endDate": "22 Juni 2026",
      "total": 700000,
      "status": "Berjalan",
    },
    {
      "id": 2,
      "customer": "Siti Nurhaliza",
      "car": "Honda Brio",
      "driver": "-",
      "startDate": "25 Juni 2026",
      "endDate": "28 Juni 2026",
      "total": 1200000,
      "status": "Selesai",
    },
  ];

  List<Map<String, dynamic>> get transactions => _transactions;

  List<Map<String, dynamic>> get filteredTransactions {
    if (searchController.text.isEmpty) {
      return transactions;
    }

    final keyword = searchController.text.toLowerCase();

    return transactions.where((trx) {
      return trx["customer"].toString().toLowerCase().contains(keyword) ||
          trx["car"].toString().toLowerCase().contains(keyword);
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
