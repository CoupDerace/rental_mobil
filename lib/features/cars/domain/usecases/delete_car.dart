import '../repositories/car_repository.dart';

class DeleteCar {
  final CarRepository repository;

  DeleteCar(this.repository);

  Future<void> call(String id) {
    return repository.deleteCar(id);
  }
}
