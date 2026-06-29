import '../repositories/pengembalian_repository.dart';

class DeletePengembalian {
  final PengembalianRepository repository;

  DeletePengembalian(this.repository);

  Future<void> call(String id) {
    return repository.deletePengembalian(id);
  }
}
