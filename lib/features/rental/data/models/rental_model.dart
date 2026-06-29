import '../../domain/entities/rental.dart';

class RentalModel extends Rental {
  final String? namaPelanggan;
  final String? namaMobil;
  final String? platNomor;
  final double? hargaSewaPerhari;

  const RentalModel({
    required super.id,
    required super.pelangganId,
    required super.mobilId,
    required super.tanggalSewa,
    required super.tanggalKembali,
    required super.totalBiaya,
    required super.statusRental,
    super.createdAt,
    this.namaPelanggan,
    this.namaMobil,
    this.platNomor,
    this.hargaSewaPerhari,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    final pelangganMap = json['pelanggan'] as Map<String, dynamic>?;
    final mobilMap = json['mobil'] as Map<String, dynamic>?;

    return RentalModel(
      id: json['id']?.toString() ?? '',
      pelangganId: json['pelanggan_id']?.toString() ?? '',
      mobilId: json['mobil_id']?.toString() ?? '',
      tanggalSewa: json['tanggal_sewa'] != null
          ? DateTime.parse(json['tanggal_sewa'])
          : DateTime.now(),
      tanggalKembali: json['tanggal_kembali'] != null
          ? DateTime.parse(json['tanggal_kembali'])
          : DateTime.now(),
      totalBiaya: (json['total_biaya'] as num?)?.toDouble() ?? 0.0,
      statusRental: json['status_rental']?.toString() ?? 'aktif',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      namaPelanggan: pelangganMap?['nama']?.toString(),
      namaMobil: mobilMap?['nama_mobil']?.toString(),
      platNomor: mobilMap?['plat_nomor']?.toString(),
      hargaSewaPerhari: (mobilMap?['harga_sewa_perhari'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pelanggan_id': pelangganId,
      'mobil_id': mobilId,
      'tanggal_sewa': tanggalSewa.toIso8601String().split('T')[0],
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'total_biaya': totalBiaya,
      'status_rental': statusRental,
    };
  }
}
