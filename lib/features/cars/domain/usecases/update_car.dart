import '../entities/car.dart';
import '../repositories/car_repository.dart';

class UpdateCar {
  final CarRepository repository;

  UpdateCar(this.repository);

  Future<void> call(String id, Car car) {
    return repository.updateCar(id, car);
  }
}
