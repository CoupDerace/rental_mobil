import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/theme/app_theme.dart';
import 'package:rental_mobil/shared/providers/theme_provider.dart';

import 'router.dart';


class RentalMobilApp extends ConsumerWidget {
  const RentalMobilApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'Rental Mobil',

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: mode,

      routerConfig: appRouter,
    );
  }
}