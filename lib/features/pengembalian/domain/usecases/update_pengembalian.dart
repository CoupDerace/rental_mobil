import '../entities/pengembalian.dart';
import '../repositories/pengembalian_repository.dart';

class UpdatePengembalian {
  final PengembalianRepository repository;

  UpdatePengembalian(this.repository);

  Future<void> call(String id, Pengembalian pengembalian) {
    return repository.updatePengembalian(id, pengembalian);
  }
}
