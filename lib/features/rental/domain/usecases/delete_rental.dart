import '../repositories/rental_repository.dart';

class DeleteRental {
  final RentalRepository repository;

  DeleteRental(this.repository);

  Future<void> call(String id) {
    return repository.deleteRental(id);
  }
}
