class Service {
  final String id;
  final String mobilId;
  final DateTime tanggalServis;
  final String jenisServis;
  final double biayaServis;
  final String? keterangan;
  final String statusServis;
  final DateTime? createdAt;

  const Service({
    required this.id,
    required this.mobilId,
    required this.tanggalServis,
    required this.jenisServis,
    required this.biayaServis,
    this.keterangan,
    this.statusServis = 'proses',
    this.createdAt,
  });
}
