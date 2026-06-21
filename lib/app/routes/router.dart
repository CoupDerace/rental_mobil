import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),

    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

    GoRoute(
      path: AppRoutes.dashboard,
      builder: (_, __) => const DashboardPage(),
    ),
  ],

  errorBuilder: (_, __) {
    return const Scaffold(body: Center(child: Text("404 Not Found")));
  },
);
