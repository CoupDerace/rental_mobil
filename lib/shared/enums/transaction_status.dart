enum TransactionStatus { pending, paid, ongoing, completed, cancelled }

extension TransactionStatusExtension on TransactionStatus {
  String get label {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';

      case TransactionStatus.paid:
        return 'Paid';

      case TransactionStatus.ongoing:
        return 'Ongoing';

      case TransactionStatus.completed:
        return 'Completed';

      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
