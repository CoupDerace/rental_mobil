import '../entities/active_service.dart';
import '../entities/dashboard.dart';
import '../entities/recent_activity.dart';
import '../entities/statistic.dart';

abstract class DashboardRepository {
  Future<Dashboard> getDashboard();
  Future<List<RecentActivity>> getRecentActivities();
  Future<List<Statistic>> getStatistics();
  Future<List<ActiveService>> getActiveServices();
}
