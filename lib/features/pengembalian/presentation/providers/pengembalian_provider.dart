import 'package:flutter/material.dart';
import '../../../rental/domain/entities/rental.dart';
import '../../../rental/domain/usecases/get_rental.dart';
import '../../data/models/pengembalian_model.dart';
import '../../domain/entities/pengembalian.dart';
import '../../domain/usecases/add_pengembalian.dart';
import '../../domain/usecases/delete_pengembalian.dart';
import '../../domain/usecases/get_pengembalian.dart';
import '../../domain/usecases/search_pengembalian.dart';
import '../../domain/usecases/update_pengembalian.dart';

class PengembalianProvider extends ChangeNotifier {
  final GetPengembalian getPengembalianUseCase;
  final AddPengembalian addPengembalianUseCase;
  final UpdatePengembalian updatePengembalianUseCase;
  final DeletePengembalian deletePengembalianUseCase;
  final SearchPengembalian searchPengembalianUseCase;
  final GetRental getRentalUseCase;

  PengembalianProvider({
    required this.getPengembalianUseCase,
    required this.addPengembalianUseCase,
    required this.updatePengembalianUseCase,
    required this.deletePengembalianUseCase,
    required this.searchPengembalianUseCase,
    required this.getRentalUseCase,
  });

  final searchController = TextEditingController();

  List<Pengembalian> _pengembalians = [];
  List<Rental> _rentals = [];
  bool _loading = false;
  String? _error;

  List<Pengembalian> get pengembalians => _pengembalians;
  List<Rental> get rentals => _rentals;
  bool get loading => _loading;
  String? get error => _error;

  int _currentPage = 1;
  final int _pageSize = 5;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalPages {
    final filteredCount = filteredPengembalians.length;
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  List<Pengembalian> get filteredPengembalians {
    if (searchController.text.isEmpty) {
      return _pengembalians;
    }

    final query = searchController.text.toLowerCase();
    return _pengembalians.where((p) {
      if (p is PengembalianModel) {
        return (p.namaPelanggan?.toLowerCase().contains(query) ?? false) ||
            (p.namaMobil?.toLowerCase().contains(query) ?? false) ||
            (p.platNomor?.toLowerCase().contains(query) ?? false) ||
            p.kondisiMobil.toLowerCase().contains(query);
      }
      return p.kondisiMobil.toLowerCase().contains(query);
    }).toList();
  }

  List<Pengembalian> get paginatedPengembalians {
    final list = filteredPengembalians;
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

  Future<void> fetchPengembalians() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _pengembalians = await getPengembalianUseCase();
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
      debugPrint("Error loading pengembalian form dependencies: $e");
    }
  }

  Future<void> addPengembalian(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Pengembalian(
        id: '',
        rentalId: data['rental_id'] ?? '',
        tanggalKembali: data['tanggal_kembali'] as DateTime,
        denda: (data['denda'] as num).toDouble(),
        kondisiMobil: data['kondisi_mobil'] ?? 'Baik',
      );
      await addPengembalianUseCase(p);
      await fetchPengembalians();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePengembalian(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Pengembalian(
        id: id,
        rentalId: data['rental_id'] ?? '',
        tanggalKembali: data['tanggal_kembali'] as DateTime,
        denda: (data['denda'] as num).toDouble(),
        kondisiMobil: data['kondisi_mobil'] ?? 'Baik',
      );
      await updatePengembalianUseCase(id, p);
      await fetchPengembalians();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePengembalian(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deletePengembalianUseCase(id);
      await fetchPengembalians();
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
