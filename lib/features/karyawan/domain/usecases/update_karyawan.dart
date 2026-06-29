import '../../domain/repositories/karyawan_repository.dart';
import '../../domain/entities/karyawan.dart';

class UpdateKaryawan {
  final KaryawanRepository repository;
  UpdateKaryawan(this.repository);

  Future<void> call(KaryawanEntity karyawan) => repository.updateKaryawan(karyawan);
}
