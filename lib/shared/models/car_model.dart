class CarModel {
  final String id;
  final String brand;
  final String name;
  final String plateNumber;
  final double dailyPrice;
  final bool available;
  final String image;

  const CarModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.plateNumber,
    required this.dailyPrice,
    required this.available,
    required this.image,
  });
}