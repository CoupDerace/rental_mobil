import '../entities/car.dart';
import '../repositories/car_repository.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Future<List<Car>> call() {
    return repository.getCars();
  }
}
