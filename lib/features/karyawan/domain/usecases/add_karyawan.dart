import '../../domain/repositories/karyawan_repository.dart';
import '../../domain/entities/karyawan.dart';

class AddKaryawan {
  final KaryawanRepository repository;
  AddKaryawan(this.repository);

  Future<void> call(KaryawanEntity karyawan) => repository.addKaryawan(karyawan);
}
