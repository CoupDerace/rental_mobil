import '../entities/pengembalian.dart';
import '../repositories/pengembalian_repository.dart';

class AddPengembalian {
  final PengembalianRepository repository;

  AddPengembalian(this.repository);

  Future<void> call(Pengembalian pengembalian) {
    return repository.addPengembalian(pengembalian);
  }
}
