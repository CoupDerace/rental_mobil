import '../../domain/entities/recent_activity.dart';

class RecentActivityModel extends RecentActivity {
  const RecentActivityModel({
    required super.customerName,
    required super.carName,
    required super.status,
    required super.total,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      customerName: json["nama_pelanggan"] ?? "",
      carName: json["nama_mobil"] ?? "",
      status: json["status_rental"] ?? "",
      total: (json["total_biaya"] as num?)?.toDouble() ?? 0,
    );
  }
}