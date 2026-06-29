import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class AddPayment {
  final PaymentRepository repository;

  AddPayment(this.repository);

  Future<void> call(Payment payment) {
    return repository.addPayment(payment);
  }
}
