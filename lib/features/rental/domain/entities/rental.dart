class Rental {
  final String id;
  final String pelangganId;
  final String mobilId;
  final DateTime tanggalSewa;
  final DateTime tanggalKembali;
  final double totalBiaya;
  final String statusRental;
  final DateTime? createdAt;

  const Rental({
    required this.id,
    required this.pelangganId,
    required this.mobilId,
    required this.tanggalSewa,
    required this.tanggalKembali,
    required this.totalBiaya,
    required this.statusRental,
    this.createdAt,
  });
}
