import '../entities/karyawan.dart';

abstract class KaryawanRepository {
  Future<List<KaryawanEntity>> getKaryawan();
  Future<void> addKaryawan(KaryawanEntity karyawan);
  Future<void> updateKaryawan(KaryawanEntity karyawan);
  Future<void> deleteKaryawan(String id);
  Future<List<KaryawanEntity>> searchKaryawan(String keyword);
}
