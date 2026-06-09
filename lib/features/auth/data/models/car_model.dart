// ─── Car ───────────────────────────────────────────────────────────────────

enum CarStatus { tersedia, disewa, servis }

extension CarStatusLabel on CarStatus {
  String get label {
    switch (this) {
      case CarStatus.tersedia:
        return 'Tersedia';
      case CarStatus.disewa:
        return 'Disewa';
      case CarStatus.servis:
        return 'Servis';
    }
  }
}

class Car {
  final int id;
  final String name;
  final String type;
  final String plate;
  final CarStatus status;
  final int pricePerDay;
  final String color;

  const Car({
    required this.id,
    required this.name,
    required this.type,
    required this.plate,
    required this.status,
    required this.pricePerDay,
    required this.color,
  });
}

// ─── Customer ──────────────────────────────────────────────────────────────

class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String ktp;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.ktp,
  });
}

// ─── Driver ────────────────────────────────────────────────────────────────

enum DriverStatus { available, onDuty }

extension DriverStatusLabel on DriverStatus {
  String get label {
    switch (this) {
      case DriverStatus.available:
        return 'Tersedia';
      case DriverStatus.onDuty:
        return 'Bertugas';
    }
  }
}

class Driver {
  final int id;
  final String name;
  final String phone;
  final String license;
  final String experience;
  final DriverStatus status;

  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.license,
    required this.experience,
    required this.status,
  });
}

// ─── Transaction ───────────────────────────────────────────────────────────

enum TransactionStatus { active, completed, pending, cancelled }

extension TransactionStatusLabel on TransactionStatus {
  String get label {
    switch (this) {
      case TransactionStatus.active:
        return 'Aktif';
      case TransactionStatus.completed:
        return 'Selesai';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

class Transaction {
  final int id;
  final String customerName;
  final String carName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final TransactionStatus status;
  final String? driverName;

  const Transaction({
    required this.id,
    required this.customerName,
    required this.carName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.driverName,
  });

  int get durationDays => endDate.difference(startDate).inDays;
}

// ─── Notification ──────────────────────────────────────────────────────────

enum NotifType { success, warning, info, error }

class AppNotification {
  final int id;
  final String message;
  final String time;
  final NotifType type;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// ─── Chart Data ────────────────────────────────────────────────────────────

class RevenueDataPoint {
  final String month;
  final double revenue;
  final double target;

  const RevenueDataPoint({
    required this.month,
    required this.revenue,
    required this.target,
  });
}

class MonthlyTransactionPoint {
  final String month;
  final int count;

  const MonthlyTransactionPoint({required this.month, required this.count});
}

class TopCar {
  final String name;
  final int rentals;
  final int revenue;

  const TopCar({
    required this.name,
    required this.rentals,
    required this.revenue,
  });
}

class CarStatusCount {
  final String label;
  final int count;
  final int colorValue;

  const CarStatusCount({
    required this.label,
    required this.count,
    required this.colorValue,
  });
}

// ─── Sample Data ───────────────────────────────────────────────────────────

class SampleData {
  static final List<Car> cars = [
    const Car(
        id: 1,
        name: 'Toyota Avanza',
        type: 'MPV',
        plate: 'B 1234 XYZ',
        status: CarStatus.tersedia,
        pricePerDay: 350000,
        color: 'Putih'),
    const Car(
        id: 2,
        name: 'Honda Jazz',
        type: 'Hatchback',
        plate: 'B 5678 ABC',
        status: CarStatus.disewa,
        pricePerDay: 400000,
        color: 'Merah'),
    const Car(
        id: 3,
        name: 'Mitsubishi Xpander',
        type: 'MPV',
        plate: 'B 9012 DEF',
        status: CarStatus.tersedia,
        pricePerDay: 450000,
        color: 'Silver'),
    const Car(
        id: 4,
        name: 'Suzuki Ertiga',
        type: 'MPV',
        plate: 'B 3456 GHI',
        status: CarStatus.servis,
        pricePerDay: 320000,
        color: 'Hitam'),
    const Car(
        id: 5,
        name: 'Daihatsu Terios',
        type: 'SUV',
        plate: 'B 7890 JKL',
        status: CarStatus.tersedia,
        pricePerDay: 380000,
        color: 'Biru'),
  ];

  static final List<Customer> customers = [
    const Customer(
        id: 1,
        name: 'Budi Santoso',
        phone: '081234567890',
        email: 'budi@email.com',
        address: 'Jakarta Selatan',
        ktp: '3171012345670001'),
    const Customer(
        id: 2,
        name: 'Ani Wijaya',
        phone: '081234567891',
        email: 'ani@email.com',
        address: 'Jakarta Barat',
        ktp: '3171012345670002'),
    const Customer(
        id: 3,
        name: 'Citra Dewi',
        phone: '081234567892',
        email: 'citra@email.com',
        address: 'Jakarta Timur',
        ktp: '3171012345670003'),
    const Customer(
        id: 4,
        name: 'Dedi Kusuma',
        phone: '081234567893',
        email: 'dedi@email.com',
        address: 'Jakarta Utara',
        ktp: '3171012345670004'),
  ];

  static final List<Driver> drivers = [
    const Driver(
        id: 1,
        name: 'Eko Prasetyo',
        phone: '081234567894',
        license: 'SIM A',
        experience: '5 tahun',
        status: DriverStatus.available),
    const Driver(
        id: 2,
        name: 'Fajar Rahman',
        phone: '081234567895',
        license: 'SIM A',
        experience: '3 tahun',
        status: DriverStatus.onDuty),
    const Driver(
        id: 3,
        name: 'Gilang Satria',
        phone: '081234567896',
        license: 'SIM A',
        experience: '7 tahun',
        status: DriverStatus.available),
  ];

  static final List<Transaction> transactions = [
    Transaction(
        id: 1,
        customerName: 'Budi Santoso',
        carName: 'Toyota Avanza',
        startDate: DateTime(2026, 6, 8),
        endDate: DateTime(2026, 6, 11),
        totalPrice: 1050000,
        status: TransactionStatus.active),
    Transaction(
        id: 2,
        customerName: 'Ani Wijaya',
        carName: 'Honda Jazz',
        startDate: DateTime(2026, 6, 5),
        endDate: DateTime(2026, 6, 8),
        totalPrice: 1200000,
        status: TransactionStatus.completed),
    Transaction(
        id: 3,
        customerName: 'Citra Dewi',
        carName: 'Mitsubishi Xpander',
        startDate: DateTime(2026, 6, 7),
        endDate: DateTime(2026, 6, 12),
        totalPrice: 2250000,
        status: TransactionStatus.active,
        driverName: 'Eko Prasetyo'),
    Transaction(
        id: 4,
        customerName: 'Dedi Kusuma',
        carName: 'Daihatsu Terios',
        startDate: DateTime(2026, 6, 6),
        endDate: DateTime(2026, 6, 9),
        totalPrice: 1140000,
        status: TransactionStatus.pending),
    Transaction(
        id: 5,
        customerName: 'Budi Santoso',
        carName: 'Suzuki Ertiga',
        startDate: DateTime(2026, 5, 28),
        endDate: DateTime(2026, 6, 1),
        totalPrice: 1280000,
        status: TransactionStatus.completed),
    Transaction(
        id: 6,
        customerName: 'Ani Wijaya',
        carName: 'Toyota Avanza',
        startDate: DateTime(2026, 5, 20),
        endDate: DateTime(2026, 5, 23),
        totalPrice: 1050000,
        status: TransactionStatus.cancelled),
  ];

  static final List<AppNotification> notifications = [
    const AppNotification(
        id: 1,
        message: 'Pengembalian terlambat: Budi Santoso (Toyota Avanza)',
        time: '2 jam lalu',
        type: NotifType.warning),
    const AppNotification(
        id: 2,
        message: 'Pembayaran diterima: Ani Wijaya - Rp 2.400.000',
        time: '4 jam lalu',
        type: NotifType.success),
    const AppNotification(
        id: 3,
        message: 'Transaksi baru: Citra Dewi - Honda Jazz (3 hari)',
        time: '5 jam lalu',
        type: NotifType.info),
    const AppNotification(
        id: 4,
        message: 'Servis terjadwal: Suzuki Ertiga - besok pagi',
        time: '1 hari lalu',
        type: NotifType.warning),
    const AppNotification(
        id: 5,
        message: 'Pelanggan baru terdaftar: Dedi Kusuma',
        time: '1 hari lalu',
        type: NotifType.info),
    const AppNotification(
        id: 6,
        message: 'Kontrak Toyota Avanza diperpanjang 2 hari oleh Budi Santoso',
        time: '2 hari lalu',
        type: NotifType.info,
        isRead: true),
    const AppNotification(
        id: 7,
        message: 'Armada baru ditambahkan: Honda BR-V 2025',
        time: '3 hari lalu',
        type: NotifType.success,
        isRead: true),
  ];

  static final List<RevenueDataPoint> revenueData = [
    const RevenueDataPoint(
        month: 'Jan', revenue: 12500000, target: 14000000),
    const RevenueDataPoint(
        month: 'Feb', revenue: 15200000, target: 14000000),
    const RevenueDataPoint(
        month: 'Mar', revenue: 18900000, target: 16000000),
    const RevenueDataPoint(
        month: 'Apr', revenue: 16700000, target: 18000000),
    const RevenueDataPoint(
        month: 'Mei', revenue: 21300000, target: 20000000),
    const RevenueDataPoint(
        month: 'Jun', revenue: 24800000, target: 22000000),
  ];

  static final List<MonthlyTransactionPoint> monthlyTransactions = [
    const MonthlyTransactionPoint(month: 'Jan', count: 38),
    const MonthlyTransactionPoint(month: 'Feb', count: 45),
    const MonthlyTransactionPoint(month: 'Mar', count: 52),
    const MonthlyTransactionPoint(month: 'Apr', count: 47),
    const MonthlyTransactionPoint(month: 'Mei', count: 61),
    const MonthlyTransactionPoint(month: 'Jun', count: 68),
  ];

  static final List<TopCar> topCars = [
    const TopCar(name: 'Toyota Avanza', rentals: 45, revenue: 18000000),
    const TopCar(name: 'Honda Jazz', rentals: 38, revenue: 15200000),
    const TopCar(name: 'Mitsubishi Xpander', rentals: 32, revenue: 19200000),
    const TopCar(name: 'Suzuki Ertiga', rentals: 28, revenue: 11200000),
    const TopCar(name: 'Daihatsu Terios', rentals: 25, revenue: 10000000),
  ];

  static final List<CarStatusCount> carStatusCounts = [
    const CarStatusCount(
        label: 'Tersedia', count: 32, colorValue: 0xFF22C55E),
    const CarStatusCount(
        label: 'Disewa', count: 14, colorValue: 0xFFF59E0B),
    const CarStatusCount(
        label: 'Servis', count: 2, colorValue: 0xFFEF4444),
  ];
}
