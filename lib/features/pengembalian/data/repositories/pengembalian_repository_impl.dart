import '../../domain/entities/pengembalian.dart';
import '../../domain/repositories/pengembalian_repository.dart';
import '../datasource/pengembalian_remote_datasource.dart';
import '../models/pengembalian_model.dart';

class PengembalianRepositoryImpl implements PengembalianRepository {
  final PengembalianRemoteDataSource remoteDataSource;

  PengembalianRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Pengembalian>> getPengembalians() async {
    return await remoteDataSource.getPengembalians();
  }

  @override
  Future<void> addPengembalian(Pengembalian pengembalian) async {
    final model = PengembalianModel(
      id: pengembalian.id,
      rentalId: pengembalian.rentalId,
      tanggalKembali: pengembalian.tanggalKembali,
      denda: pengembalian.denda,
      kondisiMobil: pengembalian.kondisiMobil,
      createdAt: pengembalian.createdAt,
    );
    await remoteDataSource.addPengembalian(model);
  }

  @override
  Future<void> updatePengembalian(String id, Pengembalian pengembalian) async {
    final model = PengembalianModel(
      id: pengembalian.id,
      rentalId: pengembalian.rentalId,
      tanggalKembali: pengembalian.tanggalKembali,
      denda: pengembalian.denda,
      kondisiMobil: pengembalian.kondisiMobil,
      createdAt: pengembalian.createdAt,
    );
    await remoteDataSource.updatePengembalian(id, model);
  }

  @override
  Future<void> deletePengembalian(String id) async {
    await remoteDataSource.deletePengembalian(id);
  }

  @override
  Future<List<Pengembalian>> searchPengembalians(String query) async {
    return await remoteDataSource.searchPengembalians(query);
  }
}
