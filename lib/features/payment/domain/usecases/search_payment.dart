import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class SearchPayment {
  final PaymentRepository repository;

  SearchPayment(this.repository);

  Future<List<Payment>> call(String query) {
    return repository.searchPayments(query);
  }
}
