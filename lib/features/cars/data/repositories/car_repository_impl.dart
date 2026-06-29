import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasource/car_remote_datasource.dart';
import '../models/car_model.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;

  CarRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Car>> getCars() {
    return remoteDataSource.getCars();
  }

  @override
  Future<void> addCar(Car car) {
    final model = CarModel(
      id: car.id,
      namaMobil: car.namaMobil,
      tipe: car.tipe,
      tahun: car.tahun,
      platNomor: car.platNomor,
      hargaSewaPerhari: car.hargaSewaPerhari,
      statusMobil: car.statusMobil,
      createdAt: car.createdAt,
    );
    return remoteDataSource.addCar(model);
  }

  @override
  Future<void> updateCar(String id, Car car) {
    final model = CarModel(
      id: car.id,
      namaMobil: car.namaMobil,
      tipe: car.tipe,
      tahun: car.tahun,
      platNomor: car.platNomor,
      hargaSewaPerhari: car.hargaSewaPerhari,
      statusMobil: car.statusMobil,
      createdAt: car.createdAt,
    );
    return remoteDataSource.updateCar(id, model);
  }

  @override
  Future<void> deleteCar(String id) {
    return remoteDataSource.deleteCar(id);
  }

  @override
  Future<List<Car>> searchCars(String query) {
    return remoteDataSource.searchCars(query);
  }
}
