import '../entities/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices();
  Future<void> addService(Service service);
  Future<void> updateService(String id, Service service);
  Future<void> deleteService(String id);
  Future<List<Service>> searchServices(String query);
}
