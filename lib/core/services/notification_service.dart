import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click if needed
      },
    );

    // Create the channel explicitly
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'rental_notifications_channel',
      'Rental & Service Notifications',
      description: 'Notifications for rental due dates, overdue rentals, and service schedules.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
      await androidImplementation.requestNotificationsPermission();
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'rental_notifications_channel',
      'Rental & Service Notifications',
      channelDescription: 'Notifications for rental due dates, overdue rentals, and service schedules.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
