import '../../domain/entities/karyawan.dart';
import '../../domain/repositories/karyawan_repository.dart';

class SearchKaryawan {
  final KaryawanRepository repository;
  SearchKaryawan(this.repository);

  Future<List<KaryawanEntity>> call(String keyword) =>
      repository.searchKaryawan(keyword);
}
