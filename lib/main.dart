import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insthelper/screens/admin/add_driver.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:insthelper/components/request_permmision.dart';
import 'package:insthelper/components/theme_mode.dart';
import 'package:insthelper/firebase_options.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/map_auto_provider.dart';
import 'package:insthelper/provider/theme_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/authentication/auth_page.dart';
import 'package:insthelper/screens/authentication/sign_in.dart';
import 'package:insthelper/screens/authentication/sign_up.dart';
import 'package:insthelper/screens/admin/container.dart';
import 'package:insthelper/screens/admin/add_vehicle.dart';
import 'package:insthelper/screens/admin/alert_list.dart';
import 'package:insthelper/screens/driver/alert_list.dart';
import 'package:insthelper/screens/driver/container.dart';
import 'package:provider/provider.dart';
import 'package:insthelper/notification_service.dart';
import 'package:workmanager/workmanager.dart';

// Add this function outside of main()
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Your background task logic here
    await _showNotification();
    return Future.value(true);
  });
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          importance: Importance.max, priority: Priority.high, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await FlutterLocalNotificationsPlugin().show(
      0, 'Notification Title', 'Notification Body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RequestPermmision().requestPermission();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize NotificationService
  await NotificationService.initialize();

  // Schedule daily notification
  await NotificationService.scheduleDailyNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomescreenProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MapAuto()),
        // Add more providers as needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          Provider.of<ThemeProvider>(context).isDarkMode ? darkMode : lightMode,
      debugShowCheckedModeBanner: false,
      routes: ({
        // Admin
        '/admin': (context) => const ContainerScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/auth': (context) => AuthPage(),
        '/add': (context) => AddVehicleScreen(),
        '/alert': (context) => const AlertList(),
        '/add_driver': (context) => AddDriver(),

        //Driver
        '/driver': (context) => const DriverContainerScreen(),
        '/driver_alert': (context) => const DriverAlertList(),
      }),
      initialRoute: '/auth',
    );
  }
}
