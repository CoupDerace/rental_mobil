import '../entities/rental.dart';
import '../repositories/rental_repository.dart';

class UpdateRental {
  final RentalRepository repository;

  UpdateRental(this.repository);

  Future<void> call(String id, Rental rental) {
    return repository.updateRental(id, rental);
  }
}
