class AppRoutes {
  AppRoutes._();

  // Splash
  static const String splash = '/';

  // Auth
  static const String login = '/login';

  // Dashboard
  static const String dashboard = '/dashboard';
  static const String ownerDashboard = '/dashboard-owner';
  static const String operatorDashboard = '/dashboard-operator';

  // Users
  static const String users = '/users';
  static const String pelanggan = '/pelanggan';
  static const String addUser = '/users/add';
  static const String editUser = '/users/edit';
  static const String userDetail = '/users/detail';

  // Cars
  static const String cars = '/cars';
  static const String addCar = '/cars/add';
  static const String editCar = '/cars/edit';
  static const String carDetail = '/cars/detail';

  // Karyawan
  static const String karyawan = '/karyawan';

  // Transactions
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String payment = '/transactions/payment';
  static const String transactionDetail = '/transactions/detail';

  // Services
  static const String services = '/servis';
  static const String addService = '/servis/add';
  static const String editService = '/servis/edit';
  static const String serviceDetail = '/servis/detail';

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

  // Pengembalian
  static const String pengembalian = '/pengembalian';
}
