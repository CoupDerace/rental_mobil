class DashboardSummaryModel {
  final int totalCars;
  final int availableCars;
  final int rentedCars;
  final int totalDrivers;
  final int totalUsers;
  final double totalIncome;

  const DashboardSummaryModel({
    required this.totalCars,
    required this.availableCars,
    required this.rentedCars,
    required this.totalDrivers,
    required this.totalUsers,
    required this.totalIncome,
  });
}