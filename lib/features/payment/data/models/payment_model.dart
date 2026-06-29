import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  final String? namaPelanggan;
  final String? namaMobil;
  final double? totalBiayaRental;

  const PaymentModel({
    required super.id,
    required super.rentalId,
    required super.tanggalBayar,
    required super.jumlahBayar,
    required super.metodePembayaran,
    required super.statusPembayaran,
    super.createdAt,
    this.namaPelanggan,
    this.namaMobil,
    this.totalBiayaRental,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final rentalMap = json['rental'] as Map<String, dynamic>?;
    final pelangganMap = rentalMap?['pelanggan'] as Map<String, dynamic>?;
    final mobilMap = rentalMap?['mobil'] as Map<String, dynamic>?;

    return PaymentModel(
      id: json['id']?.toString() ?? '',
      rentalId: json['rental_id']?.toString() ?? '',
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'])
          : DateTime.now(),
      jumlahBayar: (json['jumlah_bayar'] as num?)?.toDouble() ?? 0.0,
      metodePembayaran: json['metode_pembayaran']?.toString() ?? 'Cash',
      statusPembayaran: json['status_pembayaran']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      namaPelanggan: pelangganMap?['nama']?.toString(),
      namaMobil: mobilMap?['nama_mobil']?.toString(),
      totalBiayaRental: (rentalMap?['total_biaya'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rental_id': rentalId,
      'tanggal_bayar': tanggalBayar.toIso8601String().split('T')[0],
      'jumlah_bayar': jumlahBayar,
      'metode_pembayaran': metodePembayaran,
      'status_pembayaran': statusPembayaran,
    };
  }
}
