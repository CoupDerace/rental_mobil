import '../entities/statistic.dart';
import '../repositories/dashboard_repository.dart';

class GetStatistics {

  final DashboardRepository repository;

  GetStatistics(this.repository);

  Future<List<Statistic>> call() {
    return repository.getStatistics();
  }
}