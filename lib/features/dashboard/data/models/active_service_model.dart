import '../../domain/entities/active_service.dart';

class ActiveServiceModel extends ActiveService {
  const ActiveServiceModel({
    required super.id,
    required super.mobilNama,
    required super.mobilPlat,
    required super.jenisService,
    required super.status,
    required super.tanggalMasuk,
    super.keterangan,
  });

  factory ActiveServiceModel.fromJson(Map<String, dynamic> json) {
    return ActiveServiceModel(
      id: json['id'].toString(),
      mobilNama: json['mobil_nama'] ?? json['nama_mobil'] ?? '-',
      mobilPlat: json['mobil_plat'] ?? json['plat_nomor'] ?? '-',
      jenisService: json['jenis_service'] ?? '-',
      status: json['status'] ?? '-',
      tanggalMasuk: json['tanggal_masuk'] ?? json['created_at'] ?? '-',
      keterangan: json['keterangan'],
    );
  }
}
