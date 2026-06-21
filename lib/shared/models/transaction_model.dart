class TransactionModel {
  final String id;
  final String customerName;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;

  const TransactionModel({
    required this.id,
    required this.customerName,
    required this.carId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
  });
}