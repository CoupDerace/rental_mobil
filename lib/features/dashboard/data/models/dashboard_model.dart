import '../../domain/entities/dashboard.dart';

class DashboardModel extends Dashboard {
  DashboardModel({
    required super.totalMobil,
    required super.mobilTersedia,
    required super.mobilDisewa,
    required super.totalPelanggan,
    required super.totalRental,
    required super.totalPendapatan,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalMobil: json["total_mobil"] ?? 0,
      mobilTersedia: json["mobil_tersedia"] ?? 0,
      mobilDisewa: json["mobil_disewa"] ?? 0,
      totalPelanggan: json["total_pelanggan"] ?? 0,
      totalRental: json["total_rental"] ?? 0,
      totalPendapatan:
          (json["total_pendapatan"] as num?)?.toDouble() ?? 0,
    );
  }
}
