import '../entities/rental.dart';
import '../repositories/rental_repository.dart';

class AddRental {
  final RentalRepository repository;

  AddRental(this.repository);

  Future<void> call(Rental rental) {
    return repository.addRental(rental);
  }
}
