import '../entities/service.dart';
import '../repositories/service_repository.dart';

class AddService {
  final ServiceRepository repository;

  AddService(this.repository);

  Future<void> call(Service service) {
    return repository.addService(service);
  }
}
