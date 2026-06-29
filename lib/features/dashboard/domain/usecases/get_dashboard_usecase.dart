import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {

  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<Dashboard> call() {

    return repository.getDashboard();

  }
}