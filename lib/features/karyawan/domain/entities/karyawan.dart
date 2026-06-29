class KaryawanEntity {
  final String id;
  final String namaKaryawan;
  final String alamat;
  final String noHp;
  final String jabatan;
  final String tanggalMasuk;
  final String statusKaryawan;
  final DateTime? createdAt;

  const KaryawanEntity({
    required this.id,
    required this.namaKaryawan,
    required this.alamat,
    required this.noHp,
    required this.jabatan,
    required this.tanggalMasuk,
    required this.statusKaryawan,
    this.createdAt,
  });
}
