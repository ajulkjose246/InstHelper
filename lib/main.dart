import 'dart:async';

import 'package:AjceTrips/screens/authentication/AuthWrapper.dart';
import 'package:AjceTrips/screens/normal/alert_list.dart';
import 'package:AjceTrips/screens/normal/container.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:AjceTrips/screens/admin/add_driver.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:AjceTrips/components/request_permmision.dart';
import 'package:AjceTrips/components/theme_mode.dart';
import 'package:AjceTrips/firebase_options.dart';
import 'package:AjceTrips/provider/homescreen_provider.dart';
import 'package:AjceTrips/provider/map_auto_provider.dart';
import 'package:AjceTrips/provider/theme_provider.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:AjceTrips/screens/authentication/auth_page.dart';
import 'package:AjceTrips/screens/authentication/sign_in.dart';
import 'package:AjceTrips/screens/authentication/sign_up.dart';
import 'package:AjceTrips/screens/admin/container.dart';
import 'package:AjceTrips/screens/admin/add_vehicle.dart';
import 'package:AjceTrips/screens/admin/alert_list.dart';
import 'package:AjceTrips/screens/driver/alert_list.dart';
import 'package:AjceTrips/screens/driver/container.dart';
import 'package:provider/provider.dart';
import 'package:AjceTrips/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Add this function outside of main()
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task started");
    await NotificationService.checkAndNotify();
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

  // Check for app updates
  await checkForUpdates();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize NotificationService
  await NotificationService.initialize();

  // Initialize Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Schedule periodic task
  await Workmanager().registerPeriodicTask(
    "1",
    "checkDocuments",
    frequency: Duration(hours: 24),
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );

  // Schedule daily notification
  await NotificationService.scheduleDailyNotification();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
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
      child: const MyApp(),
    ),
  );
}

Future<void> checkForUpdates() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    final versionsRef = FirebaseFirestore.instance.collection('Versions');
    final QuerySnapshot versionsSnapshot = await versionsRef.get();

    String latestVersion = '0.0.0';
    String downloadUrl = '';

    for (var doc in versionsSnapshot.docs) {
      String version = doc.id;
      if (compareVersions(version, latestVersion) > 0) {
        latestVersion = version;
        downloadUrl = doc.get('url') as String;
        print(downloadUrl);
        print(latestVersion);
      }
    }

    if (compareVersions(latestVersion, currentVersion) > 0) {
      // Schedule the dialog to be shown after the app is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showUpdateDialog(latestVersion, downloadUrl);
      });
    }
  } catch (e) {
    print('Error checking for updates: $e');
  }
}

int compareVersions(String v1, String v2) {
  var v1Parts = v1.split('.').map(int.parse).toList();
  var v2Parts = v2.split('.').map(int.parse).toList();

  for (int i = 0; i < 3; i++) {
    if (v1Parts[i] > v2Parts[i]) return 1;
    if (v1Parts[i] < v2Parts[i]) return -1;
  }
  return 0;
}

void showUpdateDialog(String latestVersion, String downloadUrl) {
  if (navigatorKey.currentContext != null) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A new version ($latestVersion) of the app is available.'),
              SizedBox(height: 10),
              Text('Update URL:'),
              Text(downloadUrl, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Copy URL'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: downloadUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('URL copied to clipboard')),
                );
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                try {
                  String cleanUrl =
                      downloadUrl.trim().replaceAll(RegExp(r'^"|"$'), '');
                  final url = Uri.parse(cleanUrl);
                  if (await canLaunchUrl(url)) {
                    bool launched = await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                    if (!launched) {
                      throw 'Could not launch $url';
                    }
                  } else {
                    throw 'Could not launch $url';
                  }
                } catch (e) {
                  print('Error launching URL: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to open update link. URL copied to clipboard instead.')),
                  );
                  Clipboard.setData(ClipboardData(text: downloadUrl));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    print('Navigator context is null. Unable to show update dialog.');
  }
}

// Add this at the top of the file, outside of any class
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Add this line
      theme:
          Provider.of<ThemeProvider>(context).isDarkMode ? darkMode : lightMode,
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(
        child: const AuthPage(),
      ),
      routes: ({
        // Admin User
        '/admin': (context) => const ContainerScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/auth': (context) => const AuthPage(),
        '/add': (context) => const AddVehicleScreen(),
        '/alert': (context) => const AlertList(),
        '/add_driver': (context) => const AddDriver(),

        //Driver User
        '/driver': (context) => const DriverContainerScreen(),
        '/driver_alert': (context) => const DriverAlertList(),

        //Normal User
        '/user': (context) => const NormalContainerScreen(),
        '/user_alert': (context) => const NormalAlertList(),
      }),
      // Remove the initialRoute property
    );
  }
}
