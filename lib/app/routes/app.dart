import 'package:flutter/material.dart';
import 'package:rental_mobil/app/theme/app_theme.dart';

import 'router.dart';
import 'routes.dart';

class RentalMobilApp extends StatelessWidget {
  const RentalMobilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Mobil',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,

      onGenerateRoute: AppRouter.generate,
    );
  }
}
