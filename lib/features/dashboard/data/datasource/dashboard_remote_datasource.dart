import 'package:rental_mobil/core/network/supabase_service.dart';

import '../models/active_service_model.dart';
import '../models/dashboard_model.dart';
import '../models/recent_activity.dart';
import '../models/statistic_model.dart';

abstract class DashboardRemoteDatasource {
  Future<DashboardModel> getDashboard();
  Future<List<RecentActivityModel>> getRecentActivities();
  Future<List<StatisticModel>> getStatistics();
  Future<List<ActiveServiceModel>> getActiveServices();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  @override
  Future<DashboardModel> getDashboard() async {
    final response = await SupabaseService.from('dashboard_summary').select().single();
    return DashboardModel(
      totalMobil: (response['total_mobil'] as num?)?.toInt() ?? 0,
      mobilTersedia: (response['mobil_tersedia'] as num?)?.toInt() ?? 0,
      mobilDisewa: (response['mobil_disewa'] as num?)?.toInt() ?? 0,
      totalPelanggan: (response['total_pelanggan'] as num?)?.toInt() ?? 0,
      totalRental: (response['total_rental'] as num?)?.toInt() ?? 0,
      totalPendapatan: (response['total_pendapatan'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities() async {
    final result = await SupabaseService.from('laporan_transaksi_rental')
        .select()
        .order('created_at', ascending: false)
        .limit(5);
    return (result as List).map((e) {
      return RecentActivityModel(
        customerName: e['nama_pelanggan'] ?? 'Pelanggan',
        carName: e['nama_mobil'] ?? 'Mobil',
        status: e['status_rental'] ?? 'Selesai',
        total: (e['total_biaya'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  @override
  Future<List<StatisticModel>> getStatistics() async {
    final d = await getDashboard();
    return [
      StatisticModel(title: 'Mobil', value: d.totalMobil),
      StatisticModel(title: 'Rental', value: d.totalRental),
      StatisticModel(title: 'Pelanggan', value: d.totalPelanggan),
      StatisticModel(title: 'Disewa', value: d.mobilDisewa),
    ];
  }

  @override
  Future<List<ActiveServiceModel>> getActiveServices() async {
    final result = await SupabaseService.from('servis')
        .select()
        .eq('status', 'Proses');
    return (result as List)
        .map((e) => ActiveServiceModel.fromJson(e))
        .toList();
  }
}
