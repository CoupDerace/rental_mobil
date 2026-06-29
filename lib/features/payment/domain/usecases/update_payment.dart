import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class UpdatePayment {
  final PaymentRepository repository;

  UpdatePayment(this.repository);

  Future<void> call(String id, Payment payment) {
    return repository.updatePayment(id, payment);
  }
}
