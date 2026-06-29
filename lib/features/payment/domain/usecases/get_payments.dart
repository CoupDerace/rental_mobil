import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPayments {
  final PaymentRepository repository;

  GetPayments(this.repository);

  Future<List<Payment>> call() {
    return repository.getPayments();
  }
}
