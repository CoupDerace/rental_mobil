import '../entities/rental.dart';

abstract class RentalRepository {
  Future<List<Rental>> getRentals();
  Future<void> addRental(Rental rental);
  Future<void> updateRental(String id, Rental rental);
  Future<void> deleteRental(String id);
  Future<List<Rental>> searchRentals(String query);
}
