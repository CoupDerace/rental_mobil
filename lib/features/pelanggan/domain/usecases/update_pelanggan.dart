import '../entities/pelanggan.dart';
import '../repositories/pelanggan_repository.dart';

class UpdatePelanggan {
  final PelangganRepository repository;

  UpdatePelanggan(this.repository);

  Future<void> call(String id, Pelanggan pelanggan) {
    return repository.updatePelanggan(id, pelanggan);
  }
}
