import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/app/routes/injector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/config/supabase_config.dart';
import 'app/routes/app.dart';

import 'shared/providers/auth_provider.dart';
import 'shared/providers/theme_provider.dart';
import 'features/splash/presentation/providers/splash_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/background_service.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
  }

  await initInjector();

  // Initialize notification and background services
  await NotificationService.initialize();
  await BackgroundService.initialize();
  await BackgroundService.startPeriodicTask();

  final authProvider = AuthProvider();
  sl.registerSingleton<AuthProvider>(authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => sl<NotificationProvider>()..getUnreadCount(),
        ),
      ],
      child: const RentalMobilApp(),
    ),
  );
}
