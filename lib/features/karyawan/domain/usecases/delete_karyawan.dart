import '../../domain/repositories/karyawan_repository.dart';

class DeleteKaryawan {
  final KaryawanRepository repository;
  DeleteKaryawan(this.repository);

  Future<void> call(String id) => repository.deleteKaryawan(id);
}
