import '../entities/pelanggan.dart';

abstract class PelangganRepository {
  Future<List<Pelanggan>> getPelanggan();
  Future<void> addPelanggan(Pelanggan pelanggan);
  Future<void> updatePelanggan(String id, Pelanggan pelanggan);
  Future<void> deletePelanggan(String id);
  Future<List<Pelanggan>> searchPelanggan(String query);
}
