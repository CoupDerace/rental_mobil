import '../../domain/entities/karyawan.dart';
import '../../domain/repositories/karyawan_repository.dart';

class GetKaryawan {
  final KaryawanRepository repository;
  GetKaryawan(this.repository);

  Future<List<KaryawanEntity>> call() => repository.getKaryawan();
}
