import '../../domain/entities/pengembalian.dart';

class PengembalianModel extends Pengembalian {
  final String? namaPelanggan;
  final String? namaMobil;
  final String? platNomor;

  const PengembalianModel({
    required super.id,
    required super.rentalId,
    required super.tanggalKembali,
    required super.denda,
    required super.kondisiMobil,
    super.createdAt,
    this.namaPelanggan,
    this.namaMobil,
    this.platNomor,
  });

  factory PengembalianModel.fromJson(Map<String, dynamic> json) {
    final rentalMap = json['rental'] as Map<String, dynamic>?;
    final pelangganMap = rentalMap?['pelanggan'] as Map<String, dynamic>?;
    final mobilMap = rentalMap?['mobil'] as Map<String, dynamic>?;

    return PengembalianModel(
      id: json['id']?.toString() ?? '',
      rentalId: json['rental_id']?.toString() ?? '',
      tanggalKembali: json['tanggal_kembali'] != null
          ? DateTime.parse(json['tanggal_kembali'])
          : DateTime.now(),
      denda: (json['denda'] as num?)?.toDouble() ?? 0.0,
      kondisiMobil: json['kondisi_mobil']?.toString() ?? 'Baik',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      namaPelanggan: pelangganMap?['nama']?.toString(),
      namaMobil: mobilMap?['nama_mobil']?.toString(),
      platNomor: mobilMap?['plat_nomor']?.toString(),
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
