import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/app/theme/app_theme.dart';
import '../../shared/providers/theme_provider.dart';

import 'router.dart';
import 'routes.dart';

class RentalMobilApp extends StatelessWidget {
  const RentalMobilApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Rental Mobil',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: themeProvider.themeMode,

      initialRoute: AppRoutes.splash,

      onGenerateRoute: AppRouter.generate,
    );
  }
}
