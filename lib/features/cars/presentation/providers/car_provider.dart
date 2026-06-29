import 'package:flutter/material.dart';
import '../../domain/entities/car.dart';
import '../../domain/usecases/add_car.dart';
import '../../domain/usecases/delete_car.dart';
import '../../domain/usecases/get_car.dart';
import '../../domain/usecases/search_car.dart';
import '../../domain/usecases/update_car.dart';

class CarsProvider extends ChangeNotifier {
  final GetCars getCars;
  final AddCar addCarUseCase;
  final UpdateCar updateCarUseCase;
  final DeleteCar deleteCarUseCase;
  final SearchCar searchCarUseCase;

  CarsProvider({
    required this.getCars,
    required this.addCarUseCase,
    required this.updateCarUseCase,
    required this.deleteCarUseCase,
    required this.searchCarUseCase,
  });

  final searchController = TextEditingController();

  List<Car> _cars = [];
  bool _loading = false;
  String? _error;

  List<Car> get cars => _cars;
  bool get loading => _loading;
  String? get error => _error;

  List<Car> get filteredCars {
    if (searchController.text.isEmpty) {
      return cars;
    }

    final keyword = searchController.text.toLowerCase();
    return cars.where((car) {
      return car.namaMobil.toLowerCase().contains(keyword) ||
          car.platNomor.toLowerCase().contains(keyword) ||
          car.tipe.toLowerCase().contains(keyword);
    }).toList();
  }

  void onSearchChanged(String query) {
    notifyListeners();
  }

  Future<void> fetchCars() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _cars = await getCars();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addCar(Map<String, dynamic> carData) async {
    _loading = true;
    notifyListeners();
    try {
      final car = Car(
        id: '',
        namaMobil: carData['nama_mobil'] ?? '',
        tipe: carData['tipe'] ?? '',
        tahun: carData['tahun'] ?? 2023,
        platNomor: carData['plat_nomor'] ?? '',
        hargaSewaPerhari: (carData['harga_sewa_perhari'] as num?)?.toDouble() ?? 0.0,
        statusMobil: carData['status_mobil'] ?? 'tersedia',
        createdAt: DateTime.now(),
      );
      await addCarUseCase(car);
      await fetchCars();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCar(String id, Map<String, dynamic> carData) async {
    _loading = true;
    notifyListeners();
    try {
      final car = Car(
        id: id,
        namaMobil: carData['nama_mobil'] ?? '',
        tipe: carData['tipe'] ?? '',
        tahun: carData['tahun'] ?? 2023,
        platNomor: carData['plat_nomor'] ?? '',
        hargaSewaPerhari: (carData['harga_sewa_perhari'] as num?)?.toDouble() ?? 0.0,
        statusMobil: carData['status_mobil'] ?? 'tersedia',
        createdAt: DateTime.now(),
      );
      await updateCarUseCase(id, car);
      await fetchCars();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCar(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteCarUseCase(id);
      await fetchCars();
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
