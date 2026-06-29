import 'package:flutter/material.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';


import '../../domain/entities/active_service.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/entities/recent_activity.dart';
import '../../domain/entities/statistic.dart';
import '../../domain/usecases/get_active_services.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/usecases/get_recent_activities.dart';
import '../../domain/usecases/get_statistics.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardUseCase getDashboardUseCase;
  final GetRecentActivities getRecentActivities;
  final GetStatistics getStatistics;
  final GetActiveServices getActiveServices;

  DashboardProvider({
    required this.getDashboardUseCase,
    required this.getRecentActivities,
    required this.getStatistics,
    required this.getActiveServices,
  });

  Dashboard? dashboard;
  List<RecentActivity> recentActivities = [];
  List<Statistic> statistics = [];
  List<ActiveService> activeServices = [];
  List<Map<String, dynamic>> recentPayments = [];
  bool loading = false;
  String? error;

  Future<void> loadDashboard() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      dashboard = await getDashboardUseCase();
      recentActivities = await getRecentActivities();
      statistics = await getStatistics();
      
      final payRes = await SupabaseService.from('laporan_pendapatan')
          .select()
          .order('tanggal_bayar', ascending: false)
          .limit(5);
      recentPayments = List<Map<String, dynamic>>.from(payRes);
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> loadRecentActivities() async {
    try {
      recentActivities = await getRecentActivities();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadStatistics() async {
    try {
      statistics = await getStatistics();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadActiveServices() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      activeServices = await getActiveServices();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
