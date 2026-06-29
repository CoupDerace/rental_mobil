import '../entities/pelanggan.dart';
import '../repositories/pelanggan_repository.dart';

class SearchPelanggan {
  final PelangganRepository repository;

  SearchPelanggan(this.repository);

  Future<List<Pelanggan>> call(String query) {
    return repository.searchPelanggan(query);
  }
}
