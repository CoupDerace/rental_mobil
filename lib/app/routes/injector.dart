import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/providers/login_provider.dart';

import '../../features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_active_services.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import '../../features/dashboard/domain/usecases/get_recent_activities.dart';
import '../../features/dashboard/domain/usecases/get_statistics.dart';
import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/karyawan/data/datasource/karyawan_remote_datasource.dart';
import '../../features/karyawan/data/repositories/karyawan_repository_impl.dart';
import '../../features/karyawan/domain/repositories/karyawan_repository.dart';
import '../../features/karyawan/domain/usecases/get_karyawan.dart';
import '../../features/karyawan/domain/usecases/add_karyawan.dart';
import '../../features/karyawan/domain/usecases/update_karyawan.dart';
import '../../features/karyawan/domain/usecases/delete_karyawan.dart';
import '../../features/karyawan/domain/usecases/search_karyawan.dart';
import '../../features/karyawan/presentation/providers/karyawan_provider.dart';

import '../../features/cars/data/datasource/car_remote_datasource.dart';
import '../../features/cars/data/repositories/car_repository_impl.dart';
import '../../features/cars/domain/repositories/car_repository.dart';
import '../../features/cars/domain/usecases/add_car.dart';
import '../../features/cars/domain/usecases/delete_car.dart';
import '../../features/cars/domain/usecases/get_car.dart';
import '../../features/cars/domain/usecases/search_car.dart';
import '../../features/cars/domain/usecases/update_car.dart';
import '../../features/cars/presentation/providers/car_provider.dart';

import '../../features/pelanggan/data/datasource/pelanggan_remote_datasource.dart';
import '../../features/pelanggan/data/repositories/pelanggan_repository_impl.dart';
import '../../features/pelanggan/domain/repositories/pelanggan_repository.dart';
import '../../features/pelanggan/domain/usecases/add_pelanggan.dart';
import '../../features/pelanggan/domain/usecases/delete_pelanggan.dart';
import '../../features/pelanggan/domain/usecases/get_pelanggan.dart';
import '../../features/pelanggan/domain/usecases/search_pelanggan.dart';
import '../../features/pelanggan/domain/usecases/update_pelanggan.dart';
import '../../features/pelanggan/presentation/providers/pelanggan_provider.dart';

import '../../features/rental/data/datasource/rental_remote_datasource.dart';
import '../../features/rental/data/repositories/rental_repository_impl.dart';
import '../../features/rental/domain/repositories/rental_repository.dart';
import '../../features/rental/domain/usecases/add_rental.dart';
import '../../features/rental/domain/usecases/delete_rental.dart';
import '../../features/rental/domain/usecases/get_rental.dart';
import '../../features/rental/domain/usecases/search_rental.dart';
import '../../features/rental/domain/usecases/update_rental.dart';
import '../../features/rental/presentation/providers/rental_provider.dart';

import '../../features/users/data/datasource/user_remote_datasource.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/domain/usecases/add_user.dart';
import '../../features/users/domain/usecases/delete_user.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/domain/usecases/search_user.dart';
import '../../features/users/domain/usecases/update_user.dart';
import '../../features/users/presentation/providers/users_provider.dart';

import '../../features/payment/data/datasource/payment_remote_datasource.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/add_payment.dart';
import '../../features/payment/domain/usecases/delete_payment.dart';
import '../../features/payment/domain/usecases/get_payments.dart';
import '../../features/payment/domain/usecases/search_payment.dart';
import '../../features/payment/domain/usecases/update_payment.dart';
import '../../features/payment/presentation/providers/payment_provider.dart';

import '../../features/pengembalian/data/datasource/pengembalian_remote_datasource.dart';
import '../../features/pengembalian/data/repositories/pengembalian_repository_impl.dart';
import '../../features/pengembalian/domain/repositories/pengembalian_repository.dart';
import '../../features/pengembalian/domain/usecases/add_pengembalian.dart';
import '../../features/pengembalian/domain/usecases/delete_pengembalian.dart';
import '../../features/pengembalian/domain/usecases/get_pengembalian.dart';
import '../../features/pengembalian/domain/usecases/search_pengembalian.dart';
import '../../features/pengembalian/domain/usecases/update_pengembalian.dart';
import '../../features/pengembalian/presentation/providers/pengembalian_provider.dart';

import '../../features/services/data/datasource/service_remote_datasource.dart';
import '../../features/services/data/repositories/service_repository_impl.dart';
import '../../features/services/domain/repositories/service_repository.dart';
import '../../features/services/domain/usecases/add_service.dart';
import '../../features/services/domain/usecases/delete_service.dart';
import '../../features/services/domain/usecases/get_services.dart';
import '../../features/services/domain/usecases/search_service.dart';
import '../../features/services/domain/usecases/update_service.dart';
import '../../features/services/presentation/providers/service_provider.dart';

import '../../features/reports/data/datasource/report_remote_datasource.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/domain/usecases/get_reports.dart';
import '../../features/reports/presentation/providers/reports_provider.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  // ================= CARS =================
  sl.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<CarRepository>(
    () => CarRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetCars(sl()),
  );

  sl.registerLazySingleton(
    () => AddCar(sl()),
  );

  sl.registerLazySingleton(
    () => UpdateCar(sl()),
  );

  sl.registerLazySingleton(
    () => DeleteCar(sl()),
  );

  sl.registerLazySingleton(
    () => SearchCar(sl()),
  );

  sl.registerFactory(
    () => CarsProvider(
      getCars: sl(),
      addCarUseCase: sl(),
      updateCarUseCase: sl(),
      deleteCarUseCase: sl(),
      searchCarUseCase: sl(),
    ),
  );

  // ================= KARYAWAN =================
  sl.registerLazySingleton<KaryawanRemoteDataSource>(
    () => KaryawanRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<KaryawanRepository>(
    () => KaryawanRepositoryImpl(sl()),
  );
  // Karyawan usecases
  sl.registerLazySingleton(() => GetKaryawan(sl()));
  sl.registerLazySingleton(() => AddKaryawan(sl()));
  sl.registerLazySingleton(() => UpdateKaryawan(sl()));
  sl.registerLazySingleton(() => DeleteKaryawan(sl()));
  sl.registerLazySingleton(() => SearchKaryawan(sl()));

  sl.registerFactory(
    () => KaryawanProvider(
      getKaryawanUseCase: sl(),
      addKaryawanUseCase: sl(),
      updateKaryawanUseCase: sl(),
      deleteKaryawanUseCase: sl(),
      searchKaryawanUseCase: sl(),
    ),
  );

  // ================= AUTH =================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => LogoutUseCase(sl()),
  );

  sl.registerFactory(
    () => LoginProvider(
      loginUseCase: sl(),
    ),
  );

  // ================= DASHBOARD =================
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetDashboardUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => GetRecentActivities(sl()),
  );

  sl.registerLazySingleton(
    () => GetStatistics(sl()),
  );

  sl.registerLazySingleton(
    () => GetActiveServices(sl()),
  );

  sl.registerFactory(
    () => DashboardProvider(
      getDashboardUseCase: sl(),
      getRecentActivities: sl(),
      getStatistics: sl(),
      getActiveServices: sl(),
    ),
  );

  // ================= PELANGGAN =================
  sl.registerLazySingleton<PelangganRemoteDataSource>(
    () => PelangganRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PelangganRepository>(
    () => PelangganRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetPelanggan(sl()),
  );

  sl.registerLazySingleton(
    () => AddPelanggan(sl()),
  );

  sl.registerLazySingleton(
    () => UpdatePelanggan(sl()),
  );

  sl.registerLazySingleton(
    () => DeletePelanggan(sl()),
  );

  sl.registerLazySingleton(
    () => SearchPelanggan(sl()),
  );

  sl.registerFactory(
    () => PelangganProvider(
      getPelangganUseCase: sl(),
      addPelangganUseCase: sl(),
      updatePelangganUseCase: sl(),
      deletePelangganUseCase: sl(),
      searchPelangganUseCase: sl(),
    ),
  );

  // ================= RENTAL =================
  sl.registerLazySingleton<RentalRemoteDataSource>(
    () => RentalRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<RentalRepository>(
    () => RentalRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetRental(sl()));
  sl.registerLazySingleton(() => AddRental(sl()));
  sl.registerLazySingleton(() => UpdateRental(sl()));
  sl.registerLazySingleton(() => DeleteRental(sl()));
  sl.registerLazySingleton(() => SearchRental(sl()));

  sl.registerFactory(
    () => RentalProvider(
      getRentalUseCase: sl(),
      addRentalUseCase: sl(),
      updateRentalUseCase: sl(),
      deleteRentalUseCase: sl(),
      searchRentalUseCase: sl(),
      getCarsUseCase: sl(),
      getPelangganUseCase: sl(),
    ),
  );

  // ================= USERS =================
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => SearchUser(sl()));

  sl.registerFactory(
    () => UsersProvider(
      getUsersUseCase: sl(),
      addUserUseCase: sl(),
      updateUserUseCase: sl(),
      deleteUserUseCase: sl(),
      searchUserUseCase: sl(),
    ),
  );

  // ================= PAYMENT =================
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetPayments(sl()));
  sl.registerLazySingleton(() => AddPayment(sl()));
  sl.registerLazySingleton(() => UpdatePayment(sl()));
  sl.registerLazySingleton(() => DeletePayment(sl()));
  sl.registerLazySingleton(() => SearchPayment(sl()));

  sl.registerFactory(
    () => PaymentProvider(
      getPaymentsUseCase: sl(),
      addPaymentUseCase: sl(),
      updatePaymentUseCase: sl(),
      deletePaymentUseCase: sl(),
      searchPaymentUseCase: sl(),
      getRentalUseCase: sl(),
    ),
  );

  // ================= PENGEMBALIAN =================
  sl.registerLazySingleton<PengembalianRemoteDataSource>(
    () => PengembalianRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PengembalianRepository>(
    () => PengembalianRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetPengembalian(sl()));
  sl.registerLazySingleton(() => AddPengembalian(sl()));
  sl.registerLazySingleton(() => UpdatePengembalian(sl()));
  sl.registerLazySingleton(() => DeletePengembalian(sl()));
  sl.registerLazySingleton(() => SearchPengembalian(sl()));

  sl.registerFactory(
    () => PengembalianProvider(
      getPengembalianUseCase: sl(),
      addPengembalianUseCase: sl(),
      updatePengembalianUseCase: sl(),
      deletePengembalianUseCase: sl(),
      searchPengembalianUseCase: sl(),
      getRentalUseCase: sl(),
    ),
  );

  // ================= SERVICES =================
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton(() => AddService(sl()));
  sl.registerLazySingleton(() => UpdateService(sl()));
  sl.registerLazySingleton(() => DeleteService(sl()));
  sl.registerLazySingleton(() => SearchService(sl()));

  sl.registerFactory(
    () => ServiceProvider(
      getServicesUseCase: sl(),
      addServiceUseCase: sl(),
      updateServiceUseCase: sl(),
      deleteServiceUseCase: sl(),
      searchServiceUseCase: sl(),
      getCarsUseCase: sl(),
    ),
  );

  // ================= REPORTS =================
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetReports(sl()));

  sl.registerFactory(
    () => ReportsProvider(
      getReportsUseCase: sl(),
      getCarsUseCase: sl(),
      getPelangganUseCase: sl(),
      getServicesUseCase: sl(),
    ),
  );
}
