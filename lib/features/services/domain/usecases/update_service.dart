import '../entities/service.dart';
import '../repositories/service_repository.dart';

class UpdateService {
  final ServiceRepository repository;

  UpdateService(this.repository);

  Future<void> call(String id, Service service) {
    return repository.updateService(id, service);
  }
}
