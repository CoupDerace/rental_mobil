class Pengembalian {
  final String id;
  final String rentalId;
  final DateTime tanggalKembali;
  final double denda;
  final String kondisiMobil;
  final DateTime? createdAt;
  final String? namaPelanggan;
  final String? namaMobil;
  final String? platNomor;
  final DateTime? tanggalSewa;
  final DateTime? tanggalEstimasi;
  final DateTime? tanggalPengembalian;
  final double? totalBiaya;
  final double? totalBayar;
  final String? statusRental;

  const Pengembalian({
    required this.id,
    required this.rentalId,
    required this.tanggalKembali,
    required this.denda,
    required this.kondisiMobil,
    this.createdAt,
    this.namaPelanggan,
    this.namaMobil,
    this.platNomor,
    this.tanggalSewa,
    this.tanggalEstimasi,
    this.tanggalPengembalian,
    this.totalBiaya,
    this.totalBayar,
    this.statusRental,
  });
}
