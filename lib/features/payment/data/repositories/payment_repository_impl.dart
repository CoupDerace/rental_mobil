import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasource/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Payment>> getPayments() async {
    return await remoteDataSource.getPayments();
  }

  @override
  Future<void> addPayment(Payment payment) async {
    final model = PaymentModel(
      id: payment.id,
      rentalId: payment.rentalId,
      tanggalBayar: payment.tanggalBayar,
      jumlahBayar: payment.jumlahBayar,
      metodePembayaran: payment.metodePembayaran,
      statusPembayaran: payment.statusPembayaran,
      createdAt: payment.createdAt,
    );
    await remoteDataSource.addPayment(model);
  }

  @override
  Future<void> updatePayment(String id, Payment payment) async {
    final model = PaymentModel(
      id: payment.id,
      rentalId: payment.rentalId,
      tanggalBayar: payment.tanggalBayar,
      jumlahBayar: payment.jumlahBayar,
      metodePembayaran: payment.metodePembayaran,
      statusPembayaran: payment.statusPembayaran,
      createdAt: payment.createdAt,
    );
    await remoteDataSource.updatePayment(id, model);
  }

  @override
  Future<void> deletePayment(String id) async {
    await remoteDataSource.deletePayment(id);
  }

  @override
  Future<List<Payment>> searchPayments(String query) async {
    return await remoteDataSource.searchPayments(query);
  }
}
