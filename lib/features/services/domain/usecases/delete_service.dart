import '../repositories/service_repository.dart';

class DeleteService {
  final ServiceRepository repository;

  DeleteService(this.repository);

  Future<void> call(String id) {
    return repository.deleteService(id);
  }
}
