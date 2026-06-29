class Pengembalian {
  final String id;
  final String rentalId;
  final DateTime tanggalKembali;
  final double denda;
  final String kondisiMobil;
  final DateTime? createdAt;

  const Pengembalian({
    required this.id,
    required this.rentalId,
    required this.tanggalKembali,
    required this.denda,
    required this.kondisiMobil,
    this.createdAt,
  });
}
