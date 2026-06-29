import '../../domain/entities/active_service.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/entities/recent_activity.dart';
import '../../domain/entities/statistic.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remote;

  DashboardRepositoryImpl(this.remote);

  @override
  Future<Dashboard> getDashboard() {
    return remote.getDashboard();
  }

  @override
  Future<List<RecentActivity>> getRecentActivities() {
    return remote.getRecentActivities();
  }

  @override
  Future<List<Statistic>> getStatistics() {
    return remote.getStatistics();
  }

  @override
  Future<List<ActiveService>> getActiveServices() {
    return remote.getActiveServices();
  }
}
