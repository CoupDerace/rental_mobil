// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/app.dart';
import 'package:rental_mobil/app/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection (setup get_it)
  await setupInjector(); 

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/router.dart';
import 'package:rental_mobil/app/theme/dark_theme.dart';
import 'package:rental_mobil/app/theme/light_theme.dart';
import 'package:rental_mobil/shared/providers/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state tema (akan kita buat di shared)
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Rental Mobil',
      debugShowCheckedModeBanner: false,
      
      // Konfigurasi Tema
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,

      // Konfigurasi GoRouter
      routerConfig: AppRouter.router,
    );
  }
}