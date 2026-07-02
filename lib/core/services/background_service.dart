import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rental_mobil/app/config/supabase_config.dart';
import 'notification_service.dart';
import 'notification_checker.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.anonKey,
      );

      await NotificationService.initialize();

      await NotificationChecker.checkAndNotify();

      return Future.value(true);
    } catch (e) {
      debugPrint('Background Task Exception: $e');
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static const String taskName = 'com.rental_mobil.notificationTask';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> startPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      '1',
      taskName,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }
}
