import '../entities/recent_activity.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentActivities {

  final DashboardRepository repository;

  GetRecentActivities(this.repository);

  Future<List<RecentActivity>> call() {
    return repository.getRecentActivities();
  }
}