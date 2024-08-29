import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> scheduleDailyNotification() async {
    var now = tz.TZDateTime.now(tz.local);
    print("Current time: $now");

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day, // 47 minutes (adjusted to match your output)
    );

    // If the scheduled time has already passed for today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print("Scheduling notification for: $scheduledDate");

    try {
      await _notifications.zonedSchedule(
        0,
        'Vehicle Document Check',
        'Checking your vehicle documents...',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notification_channel',
            'Daily Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'Check_Documents',
      );
      print("Notification scheduled successfully");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  static Future<void> checkAndNotify() async {
    final vehicleProvider = VehicleProvider();
    await vehicleProvider.fetchAllVehicleData();
    final vehicles = vehicleProvider.vehicles.values.toList();

    final now = DateTime.now();

    for (var vehicle in vehicles) {
      final pollutionUpto =
          DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
      final fitnessUpto =
          DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
      final insuranceUpto =
          DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);

      if (pollutionUpto.isBefore(now) ||
          fitnessUpto.isBefore(now) ||
          insuranceUpto.isBefore(now)) {
        await showNotification(
          'Expired Document',
          'Vehicle ${vehicle['registration_number']} has an expired document.',
        );
      } else if (pollutionUpto.difference(now).inDays <= 30 ||
          fitnessUpto.difference(now).inDays <= 30 ||
          insuranceUpto.difference(now).inDays <= 30) {
        await showNotification(
          'Expiring Soon',
          'Vehicle ${vehicle['registration_number']} has a document expiring soon.',
        );
      }
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static Future<void> showImmediateNotification() async {
    try {
      await _notifications.show(
        1,
        'Test Notification',
        'This is a test notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
      print("Immediate notification sent successfully");
    } catch (e) {
      print("Error sending immediate notification: $e");
    }
  }

  static Future<void> requestNotificationPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }
}
