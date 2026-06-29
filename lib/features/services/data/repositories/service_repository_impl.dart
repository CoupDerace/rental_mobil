import '../../domain/entities/service.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasource/service_remote_datasource.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Service>> getServices() async {
    return await remoteDataSource.getServices();
  }

  @override
  Future<void> addService(Service service) async {
    final model = ServiceModel(
  id: service.id,
  mobilId: service.mobilId,
  tanggalServis: service.tanggalServis,
  jenisServis: service.jenisServis,
  biayaServis: service.biayaServis,
  keterangan: service.keterangan,
  createdAt: service.createdAt,
  statusServis: service.statusServis,
);
    await remoteDataSource.addService(model);
  }

  @override
  Future<void> updateService(String id, Service service) async {
    final model = ServiceModel(
  id: service.id,
  mobilId: service.mobilId,
  tanggalServis: service.tanggalServis,
  jenisServis: service.jenisServis,
  biayaServis: service.biayaServis,
  keterangan: service.keterangan,
  createdAt: service.createdAt,
  statusServis: service.statusServis,
);
    await remoteDataSource.updateService(id, model);
  }

  @override
  Future<void> deleteService(String id) async {
    await remoteDataSource.deleteService(id);
  }

  @override
  Future<List<Service>> searchServices(String query) async {
    return await remoteDataSource.searchServices(query);
  }
}
