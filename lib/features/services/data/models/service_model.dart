import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  final String? namaMobil;
  final String? platNomor;

  const ServiceModel({
    required super.id,
    required super.mobilId,
    required super.tanggalServis,
    required super.jenisServis,
    required super.biayaServis,
    super.keterangan,
    super.statusServis = 'proses',
    super.createdAt,
    this.namaMobil,
    this.platNomor,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final mobilMap = json['mobil'] as Map<String, dynamic>?;

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      mobilId: json['mobil_id']?.toString() ?? '',
      tanggalServis: json['tanggal_servis'] != null
          ? DateTime.parse(json['tanggal_servis'])
          : DateTime.now(),
      jenisServis: json['jenis_servis']?.toString() ?? 'Servis Berkala',
      biayaServis: (json['biaya_servis'] as num?)?.toDouble() ?? 0.0,
      keterangan: json['keterangan']?.toString(),
      statusServis: json['status_servis']?.toString() ?? 'proses',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      namaMobil: mobilMap?['nama_mobil']?.toString(),
      platNomor: mobilMap?['plat_nomor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobil_id': mobilId,
      'tanggal_servis': tanggalServis.toIso8601String().split('T')[0],
      'jenis_servis': jenisServis,
      'biaya_servis': biayaServis,
      'keterangan': keterangan,
      'status_servis': statusServis,
    };
  }
}
