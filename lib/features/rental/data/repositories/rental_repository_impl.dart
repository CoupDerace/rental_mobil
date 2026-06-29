import '../../domain/entities/rental.dart';
import '../../domain/repositories/rental_repository.dart';
import '../datasource/rental_remote_datasource.dart';
import '../models/rental_model.dart';

class RentalRepositoryImpl implements RentalRepository {
  final RentalRemoteDataSource remoteDataSource;

  RentalRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Rental>> getRentals() async {
    return await remoteDataSource.getRentals();
  }

  @override
  Future<void> addRental(Rental rental) async {
    final model = RentalModel(
      id: rental.id,
      pelangganId: rental.pelangganId,
      mobilId: rental.mobilId,
      tanggalSewa: rental.tanggalSewa,
      tanggalKembali: rental.tanggalKembali,
      totalBiaya: rental.totalBiaya,
      statusRental: rental.statusRental,
      createdAt: rental.createdAt,
    );
    await remoteDataSource.addRental(model);
  }

  @override
  Future<void> updateRental(String id, Rental rental) async {
    final model = RentalModel(
      id: rental.id,
      pelangganId: rental.pelangganId,
      mobilId: rental.mobilId,
      tanggalSewa: rental.tanggalSewa,
      tanggalKembali: rental.tanggalKembali,
      totalBiaya: rental.totalBiaya,
      statusRental: rental.statusRental,
      createdAt: rental.createdAt,
    );
    await remoteDataSource.updateRental(id, model);
  }

  @override
  Future<void> deleteRental(String id) async {
    await remoteDataSource.deleteRental(id);
  }

  @override
  Future<List<Rental>> searchRentals(String query) async {
    return await remoteDataSource.searchRentals(query);
  }
}
