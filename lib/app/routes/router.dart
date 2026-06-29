import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/app/routes/injector.dart';
import 'package:rental_mobil/features/dashboard/presentation/providers/dashboard_provider.dart';

import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/dashboard/presentation/pages/owner_dashboard.dart';
import '../../../features/dashboard/presentation/pages/operator_dashboard.dart';
import '../../../features/cars/presentation/pages/cars_page.dart';
import '../../../features/karyawan/presentation/pages/karyawan_page.dart';
import '../../../features/pelanggan/presentation/pages/pelanggan_page.dart';
import '../../../features/services/presentation/pages/services_page.dart';
import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import '../../../features/users/presentation/pages/users_page.dart';
import '../../../features/rental/presentation/pages/rental_page.dart';
import '../../../features/reports/presentation/pages/reports_page.dart';
import '../../../features/payment/presentation/pages/payments_page.dart';
import '../../../features/pengembalian/presentation/pages/pengembalian_page.dart';
import 'routes.dart';

import 'package:rental_mobil/shared/providers/auth_provider.dart';

class AppRouter {
  AppRouter._();

  static bool _isRouteAllowed(String routeName, String role) {
    final r = role.toLowerCase();

    // Public routes that are always allowed when authenticated
    if (routeName == AppRoutes.splash ||
        routeName == AppRoutes.profile ||
        routeName == AppRoutes.editProfile ||
        routeName == AppRoutes.settings) {
      return true;
    }

    if (r == 'admin') {
      if (routeName == AppRoutes.ownerDashboard || routeName == AppRoutes.operatorDashboard) {
        return false;
      }
      return true;
    }

    if (r == 'owner') {
      // Owner cannot access: Users, Karyawan
      if (routeName == AppRoutes.users ||
          routeName == AppRoutes.addUser ||
          routeName == AppRoutes.editUser ||
          routeName == AppRoutes.userDetail ||
          routeName == AppRoutes.karyawan) {
        return false;
      }
      if (routeName == AppRoutes.dashboard || routeName == AppRoutes.operatorDashboard) {
        return false;
      }
      return true;
    }

    if (r == 'operator') {
      // Operator must only access: Dashboard Operator, Servis, Settings, Logout
      if (routeName == AppRoutes.operatorDashboard ||
          routeName == AppRoutes.services ||
          routeName == AppRoutes.addService ||
          routeName == AppRoutes.editService ||
          routeName == AppRoutes.serviceDetail) {
        return true;
      }
      return false;
    }

    return false;
  }

  static Route<dynamic> _redirectRoute(String role) {
    final r = role.toLowerCase();
    if (r == 'owner') {
      return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => sl<DashboardProvider>()..loadDashboard(),
          child: const OwnerDashboard(),
        ),
      );
    } else if (r == 'operator') {
      return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => sl<DashboardProvider>()..loadDashboard(),
          child: const OperatorDashboard(),
        ),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => sl<DashboardProvider>()..loadDashboard(),
          child: const DashboardPage(),
        ),
      );
    }
  }

  static Route<dynamic> generate(RouteSettings settings) {
    final auth = sl<AuthProvider>();
    final routeName = settings.name ?? '';

    // If not authenticated, only allow splash and login
    if (!auth.isAuthenticated) {
      if (routeName != AppRoutes.splash && routeName != AppRoutes.login) {
        return MaterialPageRoute(builder: (_) => const LoginPage());
      }
    } else {
      // If authenticated, redirect login back to dashboard
      if (routeName == AppRoutes.login) {
        return _redirectRoute(auth.role);
      }

      // Check RBAC permissions
      if (!_isRouteAllowed(routeName, auth.role)) {
        return _redirectRoute(auth.role);
      }
    }

    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashPage());

      case AppRoutes.login:
        return _page(const LoginPage());

      case AppRoutes.dashboard:
        return _page(
          ChangeNotifierProvider(
            create: (_) => sl<DashboardProvider>()..loadDashboard(),
            child: const DashboardPage(),
          ),
        );

      case AppRoutes.ownerDashboard:
        return _page(
          ChangeNotifierProvider(
            create: (_) => sl<DashboardProvider>()..loadDashboard(),
            child: const OwnerDashboard(),
          ),
        );

      case AppRoutes.operatorDashboard:
        return _page(
          ChangeNotifierProvider(
            create: (_) => sl<DashboardProvider>()..loadDashboard(),
            child: const OperatorDashboard(),
          ),
        );

      case AppRoutes.services:
        return _page(const ServicesPage());

      case AppRoutes.cars:
        return _page(const CarsPage());

      case AppRoutes.karyawan:
        return _page(const KaryawanPage());

      case AppRoutes.pelanggan:
        return _page(const PelangganPage());

      case AppRoutes.users:
        return _page(const UsersPage());

      case AppRoutes.transactions:
      case '/rental':
        return _page(const RentalPage());

      case AppRoutes.payment:
      case '/pembayaran':
        return _page(const PaymentsPage());

      case AppRoutes.pengembalian:
        return _page(const PengembalianPage());

      case AppRoutes.reports:
        return _page(const ReportsPage());

      case AppRoutes.profile:
        return _page(const ProfilePage());

      case AppRoutes.editProfile:
        return _page(const EditProfilePage());

      case AppRoutes.settings:
        return _page(const SettingsPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }

  static MaterialPageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
