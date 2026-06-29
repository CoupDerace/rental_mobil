class ActiveService {
  final String id;
  final String mobilNama;
  final String mobilPlat;
  final String jenisService;
  final String status;
  final String tanggalMasuk;
  final String? keterangan;

  const ActiveService({
    required this.id,
    required this.mobilNama,
    required this.mobilPlat,
    required this.jenisService,
    required this.status,
    required this.tanggalMasuk,
    this.keterangan,
  });
}
