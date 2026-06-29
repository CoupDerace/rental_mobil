import '../entities/pengembalian.dart';
import '../repositories/pengembalian_repository.dart';

class GetPengembalian {
  final PengembalianRepository repository;

  GetPengembalian(this.repository);

  Future<List<Pengembalian>> call() {
    return repository.getPengembalians();
  }
}
