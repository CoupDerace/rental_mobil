import '../entities/car.dart';

abstract class CarRepository {
  Future<List<Car>> getCars();
  Future<void> addCar(Car car);
  Future<void> updateCar(String id, Car car);
  Future<void> deleteCar(String id);
  Future<List<Car>> searchCars(String query);
}
