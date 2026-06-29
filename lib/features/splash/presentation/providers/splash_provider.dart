import 'package:flutter/material.dart';

import '../../../../app/routes/routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier {
  Future<void> initialize(BuildContext context) async {
    final auth = context.read<AuthProvider>();

    await auth.loadSession();

    if (!context.mounted) return;

    if (!auth.isAuthenticated) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
      return;
    }

    final role = auth.role.toLowerCase();
    String dashboardRoute;
    if (role == 'admin') {
      dashboardRoute = AppRoutes.dashboard;
    } else if (role == 'owner') {
      dashboardRoute = AppRoutes.ownerDashboard;
    } else {
      dashboardRoute = AppRoutes.operatorDashboard;
    }

    Navigator.pushReplacementNamed(context, dashboardRoute);
  }
}