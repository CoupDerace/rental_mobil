import '../entities/rental.dart';
import '../repositories/rental_repository.dart';

class GetRental {
  final RentalRepository repository;

  GetRental(this.repository);

  Future<List<Rental>> call() {
    return repository.getRentals();
  }
}
