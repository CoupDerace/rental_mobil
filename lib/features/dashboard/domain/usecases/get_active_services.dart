import '../entities/active_service.dart';
import '../repositories/dashboard_repository.dart';

class GetActiveServices {
  final DashboardRepository repository;

  GetActiveServices(this.repository);

  Future<List<ActiveService>> call() {
    return repository.getActiveServices();
  }
}
