import 'package:flutter/material.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';

class TransactionsProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  List<Map<String, dynamic>> _transactions = [];
  bool _loading = false;
  String? _error;

  List<Map<String, dynamic>> get transactions => _transactions;
  bool get loading => _loading;
  String? get error => _error;

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

  Future<void> fetchTransactions() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.from('rental')
          .select('*, pelanggan(nama_pelanggan), mobil(nama_mobil)');
      
      _transactions = (response as List).map<Map<String, dynamic>>((e) {
        final pelanggan = e['pelanggan'] as Map<String, dynamic>?;
        final mobil = e['mobil'] as Map<String, dynamic>?;

        return {
          "id": e['id']?.toString() ?? '',
          "customer": pelanggan?['nama_pelanggan'] ?? 'Pelanggan',
          "car": mobil?['nama_mobil'] ?? 'Mobil',
          "karyawan": "-", // PIC/Karyawan
          "startDate": e['tanggal_mulai'] ?? '',
          "endDate": e['tanggal_selesai'] ?? '',
          "total": (e['total_harga'] as num?)?.toDouble() ?? 0,
          "status": e['status'] ?? 'Berjalan',
        };
      }).toList();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  void refresh() {
    fetchTransactions();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
