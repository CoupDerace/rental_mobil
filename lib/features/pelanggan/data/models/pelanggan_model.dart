import '../../domain/entities/pelanggan.dart';

class PelangganModel extends Pelanggan {
  const PelangganModel({
    required super.id,
    required super.nama,
    required super.noHp,
    super.alamat,
    required super.jenisIdentitas,
    required super.noIdentitas,
    super.fotoIdentitas,
    required super.createdAt,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      noHp: json['no_hp']?.toString() ?? '',
      alamat: json['alamat']?.toString(),
      jenisIdentitas: json['jenis_identitas']?.toString() ?? 'KTP',
      noIdentitas: json['no_identitas']?.toString() ?? '',
      fotoIdentitas: json['foto_identitas']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'no_hp': noHp,
      'alamat': alamat,
      'jenis_identitas': jenisIdentitas,
      'no_identitas': noIdentitas,
      'foto_identitas': fotoIdentitas,
    };
  }
}
