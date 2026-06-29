import '../../domain/entities/karyawan.dart';
import '../../domain/repositories/karyawan_repository.dart';
import '../datasource/karyawan_remote_datasource.dart';
import '../models/karyawan_model.dart';

class KaryawanRepositoryImpl implements KaryawanRepository {
  final KaryawanRemoteDataSource remoteDataSource;

  KaryawanRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<KaryawanEntity>> getKaryawan() =>
      remoteDataSource.getKaryawan();

  @override
  Future<void> addKaryawan(KaryawanEntity karyawan) =>
      remoteDataSource.addKaryawan(_toModel(karyawan));

  @override
  Future<void> updateKaryawan(KaryawanEntity karyawan) =>
      remoteDataSource.updateKaryawan(_toModel(karyawan));

  @override
  Future<void> deleteKaryawan(String id) =>
      remoteDataSource.deleteKaryawan(id);

  @override
  Future<List<KaryawanEntity>> searchKaryawan(String keyword) =>
      remoteDataSource.searchKaryawan(keyword);

  KaryawanModel _toModel(KaryawanEntity k) => KaryawanModel(
        id: k.id,
        namaKaryawan: k.namaKaryawan,
        alamat: k.alamat,
        noHp: k.noHp,
        jabatan: k.jabatan,
        tanggalMasuk: k.tanggalMasuk,
        statusKaryawan: k.statusKaryawan,
        createdAt: k.createdAt,
      );
}
