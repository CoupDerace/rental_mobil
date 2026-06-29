import '../../domain/entities/pelanggan.dart';
import '../../domain/repositories/pelanggan_repository.dart';
import '../datasource/pelanggan_remote_datasource.dart';
import '../models/pelanggan_model.dart';

class PelangganRepositoryImpl implements PelangganRepository {
  final PelangganRemoteDataSource remoteDataSource;

  PelangganRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Pelanggan>> getPelanggan() {
    return remoteDataSource.getPelanggan();
  }

  @override
  Future<void> addPelanggan(Pelanggan pelanggan) {
    final model = PelangganModel(
      id: pelanggan.id,
      nama: pelanggan.nama,
      noHp: pelanggan.noHp,
      alamat: pelanggan.alamat,
      jenisIdentitas: pelanggan.jenisIdentitas,
      noIdentitas: pelanggan.noIdentitas,
      fotoIdentitas: pelanggan.fotoIdentitas,
      createdAt: pelanggan.createdAt,
    );
    return remoteDataSource.addPelanggan(model);
  }

  @override
  Future<void> updatePelanggan(String id, Pelanggan pelanggan) {
    final model = PelangganModel(
      id: pelanggan.id,
      nama: pelanggan.nama,
      noHp: pelanggan.noHp,
      alamat: pelanggan.alamat,
      jenisIdentitas: pelanggan.jenisIdentitas,
      noIdentitas: pelanggan.noIdentitas,
      fotoIdentitas: pelanggan.fotoIdentitas,
      createdAt: pelanggan.createdAt,
    );
    return remoteDataSource.updatePelanggan(id, model);
  }

  @override
  Future<void> deletePelanggan(String id) {
    return remoteDataSource.deletePelanggan(id);
  }

  @override
  Future<List<Pelanggan>> searchPelanggan(String query) {
    return remoteDataSource.searchPelanggan(query);
  }
}
