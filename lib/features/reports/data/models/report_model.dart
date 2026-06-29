import 'package:intl/intl.dart';
import '../../domain/entities/report.dart';

/// Safely parses a [raw] date string (ISO 8601 with or without timezone)
/// into local time, then formats it as dd/MM/yyyy.
/// Returns '-' for null or unparseable values.
String _formatTanggalBayar(dynamic raw) {
  if (raw == null) return '-';
  final str = raw.toString().trim();
  if (str.isEmpty) return '-';
  try {
    // DateTime.parse handles ISO 8601 with timezone offset (e.g., +07:00)
    final dt = DateTime.parse(str).toLocal();
    // Guard against epoch (year <= 1970) which indicates a bad value
    if (dt.year <= 1970) return '-';
    return DateFormat('dd/MM/yyyy').format(dt);
  } catch (_) {
    return '-';
  }
}

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalPelanggan,
    required super.totalRental,
    required super.totalMobil,
    required super.mobilTersedia,
    required super.mobilDisewa,
    required super.totalPendapatan,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalPelanggan: json['total_pelanggan'] as int? ?? 0,
      totalRental: json['total_rental'] as int? ?? 0,
      totalMobil: json['total_mobil'] as int? ?? 0,
      mobilTersedia: json['mobil_tersedia'] as int? ?? 0,
      mobilDisewa: json['mobil_disewa'] as int? ?? 0,
      totalPendapatan: (json['total_pendapatan'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LaporanPendapatanModel extends LaporanPendapatan {
  const LaporanPendapatanModel({
    required super.tanggalBayar,
    required super.idPembayaran,
    required super.namaMobil,
    required super.namaPelanggan,
    required super.metodePembayaran,
    required super.jumlahBayar,
  });

  factory LaporanPendapatanModel.fromJson(Map<String, dynamic> json) {
    return LaporanPendapatanModel(
      tanggalBayar: _formatTanggalBayar(json['tanggal_bayar']),
      idPembayaran: json['id_pembayaran']?.toString() ?? '',
      namaMobil: json['nama_mobil']?.toString() ?? '',
      namaPelanggan: json['nama_pelanggan']?.toString() ?? '',
      metodePembayaran: json['metode_pembayaran']?.toString() ?? '',
      jumlahBayar: (json['jumlah_bayar'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LaporanTransaksiRentalModel extends LaporanTransaksiRental {
  const LaporanTransaksiRentalModel({
    required super.idRental,
    required super.namaPelanggan,
    required super.namaMobil,
    required super.platNomor,
    required super.tanggalSewa,
    required super.tanggalKembali,
    required super.statusRental,
    required super.totalBiaya,
    super.createdAt,
  });

  factory LaporanTransaksiRentalModel.fromJson(Map<String, dynamic> json) {
    return LaporanTransaksiRentalModel(
      idRental: json['id_rental']?.toString() ?? '',
      namaPelanggan: json['nama_pelanggan']?.toString() ?? '',
      namaMobil: json['nama_mobil']?.toString() ?? '',
      platNomor: json['plat_nomor']?.toString() ?? '',
      tanggalSewa: json['tanggal_sewa'] != null
          ? DateTime.parse(json['tanggal_sewa'])
          : DateTime.now(),
      tanggalKembali: json['tanggal_kembali'] != null
          ? DateTime.parse(json['tanggal_kembali'])
          : DateTime.now(),
      statusRental: json['status_rental']?.toString() ?? '',
      totalBiaya: (json['total_biaya'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class LaporanMobilPopulerModel extends LaporanMobilPopuler {
  const LaporanMobilPopulerModel({
    required super.namaMobil,
    required super.platNomor,
    required super.totalDisewa,
    required super.totalPendapatan,
  });

  factory LaporanMobilPopulerModel.fromJson(Map<String, dynamic> json) {
    return LaporanMobilPopulerModel(
      namaMobil: json['nama_mobil']?.toString() ?? '',
      platNomor: json['plat_nomor']?.toString() ?? '',
      totalDisewa: json['total_disewa'] as int? ?? 0,
      totalPendapatan: (json['total_pendapatan'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ViewPendapatanHarianModel extends ViewPendapatanHarian {
  const ViewPendapatanHarianModel({
    required super.tanggal,
    required super.total,
  });

  factory ViewPendapatanHarianModel.fromJson(Map<String, dynamic> json) {
    return ViewPendapatanHarianModel(
      tanggal: json['tanggal']?.toString() ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
