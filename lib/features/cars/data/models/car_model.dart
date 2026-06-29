import '../../domain/entities/car.dart';

class CarModel extends Car {
  const CarModel({
    required super.id,
    required super.namaMobil,
    required super.tipe,
    required super.tahun,
    required super.platNomor,
    required super.hargaSewaPerhari,
    required super.statusMobil,
    required super.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id']?.toString() ?? '',
      namaMobil: json['nama_mobil']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      tahun: (json['tahun'] as num?)?.toInt() ?? 2023,
      platNomor: json['plat_nomor']?.toString() ?? '',
      hargaSewaPerhari: (json['harga_sewa_perhari'] as num?)?.toDouble() ?? 0.0,
      statusMobil: json['status_mobil']?.toString() ?? 'tersedia',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_mobil': namaMobil,
      'tipe': tipe,
      'tahun': tahun,
      'plat_nomor': platNomor,
      'harga_sewa_perhari': hargaSewaPerhari,
      'status_mobil': statusMobil,
    };
  }
}
