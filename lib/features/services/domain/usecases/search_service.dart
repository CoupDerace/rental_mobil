import '../entities/service.dart';
import '../repositories/service_repository.dart';

class SearchService {
  final ServiceRepository repository;

  SearchService(this.repository);

  Future<List<Service>> call(String query) {
    return repository.searchServices(query);
  }
}
