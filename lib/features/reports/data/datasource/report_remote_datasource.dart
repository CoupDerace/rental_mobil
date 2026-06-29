import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<DashboardSummaryModel> getSummary();
  Future<List<LaporanPendapatanModel>> getPendapatan();
  Future<List<LaporanTransaksiRentalModel>> getRental();
  Future<List<LaporanMobilPopulerModel>> getMobilPopuler();
  Future<List<ViewPendapatanHarianModel>> getPendapatanHarian();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<DashboardSummaryModel> getSummary() async {
    final response = await SupabaseService.from('dashboard_summary').select();
    if (response.isNotEmpty) {
      return DashboardSummaryModel.fromJson(response.first);
    }
    return const DashboardSummaryModel(
      totalPelanggan: 0,
      totalRental: 0,
      totalMobil: 0,
      mobilTersedia: 0,
      mobilDisewa: 0,
      totalPendapatan: 0.0,
    );
  }

  @override
  Future<List<LaporanPendapatanModel>> getPendapatan() async {
    final response = await SupabaseService.from('laporan_pendapatan').select();
    return (response as List).map((e) => LaporanPendapatanModel.fromJson(e)).toList();
  }

  @override
  Future<List<LaporanTransaksiRentalModel>> getRental() async {
    final response = await SupabaseService.from('laporan_transaksi_rental').select();
    return (response as List).map((e) => LaporanTransaksiRentalModel.fromJson(e)).toList();
  }

  @override
  Future<List<LaporanMobilPopulerModel>> getMobilPopuler() async {
    final response = await SupabaseService.from('laporan_mobil_populer').select();
    return (response as List).map((e) => LaporanMobilPopulerModel.fromJson(e)).toList();
  }

  @override
  Future<List<ViewPendapatanHarianModel>> getPendapatanHarian() async {
    final response = await SupabaseService.from('view_pendapatan').select();
    return (response as List).map((e) => ViewPendapatanHarianModel.fromJson(e)).toList();
  }
}
