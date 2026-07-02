import '../../domain/entities/pengembalian.dart';

class PengembalianModel extends Pengembalian {
  const PengembalianModel({
    required super.id,
    required super.rentalId,
    required super.tanggalKembali,
    required super.denda,
    required super.kondisiMobil,
    super.createdAt,
    super.namaPelanggan,
    super.namaMobil,
    super.platNomor,
    super.tanggalSewa,
    super.tanggalEstimasi,
    super.tanggalPengembalian,
    super.totalBiaya,
    super.totalBayar,
    super.statusRental,
  });

  factory PengembalianModel.fromJson(Map<String, dynamic> json) {
    final rentalMap = json['rental'] as Map<String, dynamic>?;
    final pelangganMap = rentalMap?['pelanggan'] as Map<String, dynamic>?;
    final mobilMap = rentalMap?['mobil'] as Map<String, dynamic>?;

    return PengembalianModel(
      id: json['id']?.toString() ?? '',
      rentalId: json['rental_id']?.toString() ?? '',
      tanggalKembali: json['tanggal_pengembalian'] != null
          ? DateTime.parse(json['tanggal_pengembalian'])
          : (json['tanggal_kembali'] != null
              ? DateTime.parse(json['tanggal_kembali'])
              : DateTime.now()),
      denda: (json['denda'] as num?)?.toDouble() ?? 0.0,
      kondisiMobil: json['kondisi_mobil']?.toString() ?? 'Baik',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      namaPelanggan: json['nama_pelanggan']?.toString() ?? pelangganMap?['nama']?.toString(),
      namaMobil: json['nama_mobil']?.toString() ?? mobilMap?['nama_mobil']?.toString(),
      platNomor: json['plat_nomor']?.toString() ?? mobilMap?['plat_nomor']?.toString(),
      tanggalSewa: json['tanggal_sewa'] != null ? DateTime.parse(json['tanggal_sewa']) : null,
      tanggalEstimasi: json['tanggal_estimasi'] != null ? DateTime.parse(json['tanggal_estimasi']) : null,
      tanggalPengembalian: json['tanggal_pengembalian'] != null ? DateTime.parse(json['tanggal_pengembalian']) : null,
      totalBiaya: (json['total_biaya'] as num?)?.toDouble(),
      totalBayar: (json['total_bayar'] as num?)?.toDouble(),
      statusRental: json['status_rental']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rental_id': rentalId,
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'denda': denda,
      'kondisi_mobil': kondisiMobil,
    };
  }
}
