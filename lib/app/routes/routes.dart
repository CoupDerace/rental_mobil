class AppRoutes {
  AppRoutes._();

  // Splash
  static const String splash = '/';

  // Auth
  static const String login = '/login';

  // Dashboard
  static const String dashboard = '/dashboard';
  static const String adminDashboard = '/dashboard/admin';
  static const String ownerDashboard = '/dashboard/owner';
  static const String operatorDashboard = '/dashboard/operator';

  // Users
  static const String users = '/users';
  static const String addUser = '/users/add';
  static const String editUser = '/users/edit';
  static const String userDetail = '/users/detail';

  // Cars
  static const String cars = '/cars';
  static const String addCar = '/cars/add';
  static const String editCar = '/cars/edit';
  static const String carDetail = '/cars/detail';

  // Drivers
  static const String drivers = '/drivers';
  static const String addDriver = '/drivers/add';
  static const String editDriver = '/drivers/edit';
  static const String driverDetail = '/drivers/detail';

  // Transactions
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String payment = '/transactions/payment';
  static const String transactionDetail = '/transactions/detail';

  // Services
  static const String services = '/services';
  static const String addService = '/services/add';
  static const String editService = '/services/edit';
  static const String serviceDetail = '/services/detail';

  // Reports
  static const String reports = '/reports';
  static const String dailyReport = '/reports/daily';
  static const String monthlyReport = '/reports/monthly';
  static const String yearlyReport = '/reports/yearly';

  // Notifications
  static const String notifications = '/notifications';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Settings
  static const String settings = '/settings';
}
