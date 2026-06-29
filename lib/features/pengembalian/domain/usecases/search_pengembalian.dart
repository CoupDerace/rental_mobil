import '../entities/pengembalian.dart';
import '../repositories/pengembalian_repository.dart';

class SearchPengembalian {
  final PengembalianRepository repository;

  SearchPengembalian(this.repository);

  Future<List<Pengembalian>> call(String query) {
    return repository.searchPengembalians(query);
  }
}
