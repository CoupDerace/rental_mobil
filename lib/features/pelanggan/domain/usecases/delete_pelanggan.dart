import '../repositories/pelanggan_repository.dart';

class DeletePelanggan {
  final PelangganRepository repository;

  DeletePelanggan(this.repository);

  Future<void> call(String id) {
    return repository.deletePelanggan(id);
  }
}
