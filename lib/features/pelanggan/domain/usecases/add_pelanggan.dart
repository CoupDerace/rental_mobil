import '../entities/pelanggan.dart';
import '../repositories/pelanggan_repository.dart';

class AddPelanggan {
  final PelangganRepository repository;

  AddPelanggan(this.repository);

  Future<void> call(Pelanggan pelanggan) {
    return repository.addPelanggan(pelanggan);
  }
}
