import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RequestPermmision().requestPermission();
  // Workmanager().initialize(callbackDispatcher);

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

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await Future.delayed(Duration(seconds: 2));

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // flutterLocalNotificationsPlugin.show(
        //   888,
        //   'KL 71 KL 7171',
        //   'Awesome ${DateTime.now()}',
        //   const NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       'my_foreground',
        //       'MY FOREGROUND SERVICE',
        //       icon: 'ic_bg_service_small',
        //       ongoing: true,
        //     ),
        //   ),
        // );

        // service.setForegroundNotificationInfo(
        //   title: "My App Service",
        //   content: "Updated at ${DateTime.now()}",
        // );
      }
    }

    // service.invoke(
    //   'update',
    //   {
    //     "current_date": DateTime.now().toIso8601String(),
    //     "device": "device",
    //   },
    // );
  });
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize the local notifications plugin
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'expiry_channel_id',
      'Expiry Notifications',
      channelDescription: 'Notifications for vehicle document expiries',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      inputData?['title'],
      inputData?['body'],
      platformChannelSpecifics,
    );

    return Future.value(true);
  });
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

        //Driver
        '/driver': (context) => const DriverContainerScreen(),
        '/driver_alert': (context) => const DriverAlertList(),
      }),
      initialRoute: '/auth',
    );
  }
}
