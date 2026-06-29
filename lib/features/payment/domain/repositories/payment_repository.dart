import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getPayments();
  Future<void> addPayment(Payment payment);
  Future<void> updatePayment(String id, Payment payment);
  Future<void> deletePayment(String id);
  Future<List<Payment>> searchPayments(String query);
}
