import 'package:flutter/material.dart';
import '../../../cars/domain/entities/car.dart';
import '../../../cars/domain/usecases/get_car.dart';
import '../../../pelanggan/domain/entities/pelanggan.dart';
import '../../../pelanggan/domain/usecases/get_pelanggan.dart';
import '../../data/models/rental_model.dart';
import '../../domain/entities/rental.dart';
import '../../domain/usecases/add_rental.dart';
import '../../domain/usecases/delete_rental.dart';
import '../../domain/usecases/get_rental.dart';
import '../../domain/usecases/search_rental.dart';
import '../../domain/usecases/update_rental.dart';

class RentalProvider extends ChangeNotifier {
  final GetRental getRentalUseCase;
  final AddRental addRentalUseCase;
  final UpdateRental updateRentalUseCase;
  final DeleteRental deleteRentalUseCase;
  final SearchRental searchRentalUseCase;
  final GetCars getCarsUseCase;
  final GetPelanggan getPelangganUseCase;

  RentalProvider({
    required this.getRentalUseCase,
    required this.addRentalUseCase,
    required this.updateRentalUseCase,
    required this.deleteRentalUseCase,
    required this.searchRentalUseCase,
    required this.getCarsUseCase,
    required this.getPelangganUseCase,
  });

  final searchController = TextEditingController();

  List<Rental> _rentals = [];
  List<Pelanggan> _pelangganList = [];
  List<Car> _carsList = [];
  bool _loading = false;
  String? _error;

  List<Rental> get rentals => _rentals;
  List<Pelanggan> get pelangganList => _pelangganList;
  List<Car> get carsList => _carsList;
  bool get loading => _loading;
  String? get error => _error;

  // Pagination states
  int _currentPage = 1;
  final int _pageSize = 5; // Default 5 items per page for easily testable pagination

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalPages {
    final filteredCount = filteredRentals.length;
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  List<Rental> get filteredRentals {
    if (searchController.text.isEmpty) {
      return _rentals;
    }

    final query = searchController.text.toLowerCase();
    return _rentals.where((r) {
      if (r is RentalModel) {
        final customerMatch = r.namaPelanggan?.toLowerCase().contains(query) ?? false;
        final carMatch = r.namaMobil?.toLowerCase().contains(query) ?? false;
        final plateMatch = r.platNomor?.toLowerCase().contains(query) ?? false;
        final statusMatch = r.statusRental.toLowerCase().contains(query);
        return customerMatch || carMatch || plateMatch || statusMatch;
      } else {
        return r.statusRental.toLowerCase().contains(query) ||
            r.pelangganId.toLowerCase().contains(query) ||
            r.mobilId.toLowerCase().contains(query);
      }
    }).toList();
  }

  List<Rental> get paginatedRentals {
    final list = filteredRentals;
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
    _currentPage = 1; // Reset to page 1 on search change
    notifyListeners();
  }

  Future<void> fetchRentals() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _rentals = await getRentalUseCase();
      _currentPage = 1;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchFormDependencies() async {
    try {
      _pelangganList = await getPelangganUseCase();
      _carsList = await getCarsUseCase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading form dependencies: $e");
    }
  }

  List<Car> getAvailableCars(String? currentMobilId) {
    final cars = _carsList;
    final result = [
      ...cars.where((c) => c.statusMobil.toLowerCase() == 'tersedia'),
      if (currentMobilId != null && cars.any((c) => c.id == currentMobilId))
        cars.firstWhere((c) => c.id == currentMobilId)
    ];

    return result.fold<Map<String, Car>>(
      {},
      (map, e) {
        map[e.id] = e;
        return map;
      },
    ).values.toList();
  }

  Future<void> addRental(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final r = Rental(
        id: '',
        pelangganId: data['pelanggan_id'] ?? '',
        mobilId: data['mobil_id'] ?? '',
        tanggalSewa: data['tanggal_sewa'] as DateTime,
        tanggalKembali: data['tanggal_kembali'] as DateTime,
        totalBiaya: (data['total_biaya'] as num).toDouble(),
        statusRental: data['status_rental'] ?? 'aktif',
      );
      await addRentalUseCase(r);
      await fetchRentals();
      await fetchCars();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateRental(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final r = Rental(
        id: id,
        pelangganId: data['pelanggan_id'] ?? '',
        mobilId: data['mobil_id'] ?? '',
        tanggalSewa: data['tanggal_sewa'] as DateTime,
        tanggalKembali: data['tanggal_kembali'] as DateTime,
        totalBiaya: (data['total_biaya'] as num).toDouble(),
        statusRental: data['status_rental'] ?? 'aktif',
      );
      await updateRentalUseCase(id, r);
      await fetchRentals();
      await fetchCars();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRental(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteRentalUseCase(id);
      await fetchRentals();
      await fetchCars();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchCars() async {
    try {
      _carsList = await getCarsUseCase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
