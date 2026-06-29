class Payment {
  final String id;
  final String rentalId;
  final DateTime tanggalBayar;
  final double jumlahBayar;
  final String metodePembayaran;
  final String statusPembayaran;
  final DateTime? createdAt;

  const Payment({
    required this.id,
    required this.rentalId,
    required this.tanggalBayar,
    required this.jumlahBayar,
    required this.metodePembayaran,
    required this.statusPembayaran,
    this.createdAt,
  });
}
