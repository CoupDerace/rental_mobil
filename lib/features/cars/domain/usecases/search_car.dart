import '../entities/car.dart';
import '../repositories/car_repository.dart';

class SearchCar {
  final CarRepository repository;

  SearchCar(this.repository);

  Future<List<Car>> call(String query) {
    return repository.searchCars(query);
  }
}
