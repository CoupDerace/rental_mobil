import 'package:flutter/material.dart';
import '../../../cars/domain/entities/car.dart';
import '../../../cars/domain/usecases/get_car.dart';
import '../../data/models/service_model.dart';
import '../../domain/entities/service.dart';
import '../../domain/usecases/add_service.dart';
import '../../domain/usecases/delete_service.dart';
import '../../domain/usecases/get_services.dart';
import '../../domain/usecases/search_service.dart';
import '../../domain/usecases/update_service.dart';

class ServiceProvider extends ChangeNotifier {
  final GetServices getServicesUseCase;
  final AddService addServiceUseCase;
  final UpdateService updateServiceUseCase;
  final DeleteService deleteServiceUseCase;
  final SearchService searchServiceUseCase;
  final GetCars getCarsUseCase;

  ServiceProvider({
    required this.getServicesUseCase,
    required this.addServiceUseCase,
    required this.updateServiceUseCase,
    required this.deleteServiceUseCase,
    required this.searchServiceUseCase,
    required this.getCarsUseCase,
  });

  final searchController = TextEditingController();

  List<Service> _services = [];
  List<Car> _carsList = [];
  bool _loading = false;
  String? _error;

  List<Service> get services => _services;
  List<Car> get carsList => _carsList;
  bool get loading => _loading;
  String? get error => _error;

  int _currentPage = 1;
  final int _pageSize = 5;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalPages {
    final filteredCount = filteredServices.length;
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  List<Service> get filteredServices {
    if (searchController.text.isEmpty) {
      return _services;
    }

    final query = searchController.text.toLowerCase();
    return _services.where((s) {
      if (s is ServiceModel) {
        return (s.namaMobil?.toLowerCase().contains(query) ?? false) ||
            (s.platNomor?.toLowerCase().contains(query) ?? false) ||
            s.jenisServis.toLowerCase().contains(query);
      }
      return s.jenisServis.toLowerCase().contains(query);
    }).toList();
  }

  List<Service> get paginatedServices {
    final list = filteredServices;
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

  Future<void> fetchServices() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _services = await getServicesUseCase();
      _currentPage = 1;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchFormDependencies() async {
    try {
      _carsList = await getCarsUseCase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading services form dependencies: $e");
    }
  }

  Future<void> addService(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final s = Service(
        id: '',
        mobilId: data['mobil_id'] ?? '',
        tanggalServis: data['tanggal_servis'] as DateTime,
        jenisServis: data['jenis_servis'] ?? 'Servis Berkala',
        biayaServis: (data['biaya_servis'] as num).toDouble(),
        keterangan: data['keterangan'],
        statusServis: data['status_servis'] ?? 'proses',
      );
      await addServiceUseCase(s);
      await fetchCars();
      await fetchServices();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateService(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final s = Service(
        id: id,
        mobilId: data['mobil_id'] ?? '',
        tanggalServis: data['tanggal_servis'] as DateTime,
        jenisServis: data['jenis_servis'] ?? 'Servis Berkala',
        biayaServis: (data['biaya_servis'] as num).toDouble(),
        keterangan: data['keterangan'],
        statusServis: data['status_servis'] ?? 'proses',
      );
      await updateServiceUseCase(id, s);
      await fetchCars();
      await fetchServices();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteService(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteServiceUseCase(id);
      await fetchCars();
      await fetchServices();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCars() async {
    try {
      _carsList = await getCarsUseCase();
      debugPrint("=== FETCH CARS ===");
      for (final c in _carsList) {
        debugPrint("${c.namaMobil} ${c.statusMobil}");
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  List<Car> getAvailableServiceCars(String? currentMobilId) {
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
