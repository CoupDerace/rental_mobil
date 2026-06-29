import '../../domain/entities/karyawan.dart';

class KaryawanModel extends KaryawanEntity {
  const KaryawanModel({
    required super.id,
    required super.namaKaryawan,
    required super.alamat,
    required super.noHp,
    required super.jabatan,
    required super.tanggalMasuk,
    required super.statusKaryawan,
    super.createdAt,
  });

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      id: json['id']?.toString() ?? '',
      namaKaryawan: json['nama_karyawan'] ?? '',
      alamat: json['alamat'] ?? '',
      noHp: json['no_hp'] ?? '',
      jabatan: json['jabatan'] ?? '',
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      statusKaryawan: json['status_karyawan'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_karyawan': namaKaryawan,
      'alamat': alamat,
      'no_hp': noHp,
      'jabatan': jabatan,
      'tanggal_masuk': tanggalMasuk,
      'status_karyawan': statusKaryawan,
    };
  }
}
