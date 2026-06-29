import '../entities/rental.dart';
import '../repositories/rental_repository.dart';

class SearchRental {
  final RentalRepository repository;

  SearchRental(this.repository);

  Future<List<Rental>> call(String query) {
    return repository.searchRentals(query);
  }
}
