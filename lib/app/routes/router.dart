import 'package:flutter/material.dart';

import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/dashboard/presentation/pages/admin_dashboard.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/dashboard/presentation/pages/operator_dashboard.dart';
import '../../../features/dashboard/presentation/pages/owner_dashboard.dart';
import '../../../features/notifications/presentation/pages/notifications_page.dart';
import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashPage());

      case AppRoutes.login:
        return _page(const LoginPage());

      case AppRoutes.dashboard:
        return _page(const DashboardPage());

      case AppRoutes.adminDashboard:
        return _page(const AdminDashboard());

      case AppRoutes.ownerDashboard:
        return _page(const OwnerDashboard());

      case AppRoutes.operatorDashboard:
        return _page(const OperatorDashboard());

      case AppRoutes.notifications:
        return _page(const NotificationsPage());

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
