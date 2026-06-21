class ServiceModel {
  final String id;
  final String carId;
  final String description;
  final double cost;
  final DateTime serviceDate;

  const ServiceModel({
    required this.id,
    required this.carId,
    required this.description,
    required this.cost,
    required this.serviceDate,
  });
}