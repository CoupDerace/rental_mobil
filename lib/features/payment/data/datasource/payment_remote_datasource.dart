import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getPayments();
  Future<void> addPayment(PaymentModel payment);
  Future<void> updatePayment(String id, PaymentModel payment);
  Future<void> deletePayment(String id);
  Future<List<PaymentModel>> searchPayments(String query);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  @override
  Future<List<PaymentModel>> getPayments() async {
    final response = await SupabaseService.from('pembayaran')
        .select('''
          *,
          rental(
            id,
            total_biaya,
            pelanggan(nama),
            mobil(nama_mobil)
          )
        ''')
        .order('created_at', ascending: false);
    return (response as List).map((e) => PaymentModel.fromJson(e)).toList();
  }

  @override
  Future<void> addPayment(PaymentModel payment) async {
    await SupabaseService.from('pembayaran').insert(payment.toJson());
  }

  @override
  Future<void> updatePayment(String id, PaymentModel payment) async {
    await SupabaseService.from('pembayaran').update({
      'tanggal_bayar': payment.tanggalBayar.toIso8601String().split('T')[0],
      'jumlah_bayar': payment.jumlahBayar,
      'metode_pembayaran': payment.metodePembayaran,
      'status_pembayaran': payment.statusPembayaran,
    }).eq('id', id);
  }

  @override
  Future<void> deletePayment(String id) async {
    await SupabaseService.from('pembayaran').delete().eq('id', id);
  }

  @override
  Future<List<PaymentModel>> searchPayments(String query) async {
    final list = await getPayments();
    if (query.isEmpty) return list;
    final lowercaseQuery = query.toLowerCase();
    return list.where((p) {
      return (p.namaPelanggan?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (p.namaMobil?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          p.metodePembayaran.toLowerCase().contains(lowercaseQuery) ||
          p.statusPembayaran.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
