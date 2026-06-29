import '../entities/pelanggan.dart';
import '../repositories/pelanggan_repository.dart';

class GetPelanggan {
  final PelangganRepository repository;

  GetPelanggan(this.repository);

  Future<List<Pelanggan>> call() {
    return repository.getPelanggan();
  }
}
