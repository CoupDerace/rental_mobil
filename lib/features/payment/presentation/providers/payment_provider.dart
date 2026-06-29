import 'package:flutter/material.dart';
import '../../../rental/domain/entities/rental.dart';
import '../../../rental/domain/usecases/get_rental.dart';
import '../../data/models/payment_model.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/add_payment.dart';
import '../../domain/usecases/delete_payment.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/search_payment.dart';
import '../../domain/usecases/update_payment.dart';

class PaymentProvider extends ChangeNotifier {
  final GetPayments getPaymentsUseCase;
  final AddPayment addPaymentUseCase;
  final UpdatePayment updatePaymentUseCase;
  final DeletePayment deletePaymentUseCase;
  final SearchPayment searchPaymentUseCase;
  final GetRental getRentalUseCase;

  PaymentProvider({
    required this.getPaymentsUseCase,
    required this.addPaymentUseCase,
    required this.updatePaymentUseCase,
    required this.deletePaymentUseCase,
    required this.searchPaymentUseCase,
    required this.getRentalUseCase,
  });

  final searchController = TextEditingController();

  List<Payment> _payments = [];
  List<Rental> _rentals = [];
  bool _loading = false;
  String? _error;

  List<Payment> get payments => _payments;
  List<Rental> get rentals => _rentals;
  bool get loading => _loading;
  String? get error => _error;

  // Simple client-side pagination
  int _currentPage = 1;
  final int _pageSize = 5;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalPages {
    final filteredCount = filteredPayments.length;
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  List<Payment> get filteredPayments {
    if (searchController.text.isEmpty) {
      return _payments;
    }

    final query = searchController.text.toLowerCase();
    return _payments.where((p) {
      if (p is PaymentModel) {
        return (p.namaPelanggan?.toLowerCase().contains(query) ?? false) ||
            (p.namaMobil?.toLowerCase().contains(query) ?? false) ||
            p.metodePembayaran.toLowerCase().contains(query) ||
            p.statusPembayaran.toLowerCase().contains(query);
      }
      return p.metodePembayaran.toLowerCase().contains(query) ||
          p.statusPembayaran.toLowerCase().contains(query);
    }).toList();
  }

  List<Payment> get paginatedPayments {
    final list = filteredPayments;
    final startIndex = (_currentPage - 1) * _pageSize;
    if (startIndex >= list.length) {
      return [];
    }
    final endIndex = startIndex + _pageSize;
    return list.sublist(
      startIndex,
      endIndex > list.length ? list.length : endIndex,
    );
  }

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _currentPage = 1;
    notifyListeners();
  }

  Future<void> fetchPayments() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _payments = await getPaymentsUseCase();
      _currentPage = 1;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchFormDependencies() async {
    try {
      _rentals = await getRentalUseCase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading payment form dependencies: $e");
    }
  }

  Future<void> addPayment(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Payment(
        id: '',
        rentalId: data['rental_id'] ?? '',
        tanggalBayar: data['tanggal_bayar'] as DateTime,
        jumlahBayar: (data['jumlah_bayar'] as num).toDouble(),
        metodePembayaran: data['metode_pembayaran'] ?? 'Cash',
        statusPembayaran: data['status_pembayaran'] ?? 'pending',
      );
      await addPaymentUseCase(p);
      await fetchPayments();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePayment(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Payment(
        id: id,
        rentalId: data['rental_id'] ?? '',
        tanggalBayar: data['tanggal_bayar'] as DateTime,
        jumlahBayar: (data['jumlah_bayar'] as num).toDouble(),
        metodePembayaran: data['metode_pembayaran'] ?? 'Cash',
        statusPembayaran: data['status_pembayaran'] ?? 'pending',
      );
      await updatePaymentUseCase(id, p);
      await fetchPayments();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePayment(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deletePaymentUseCase(id);
      await fetchPayments();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
