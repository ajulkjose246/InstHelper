import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/firebase_options.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/map_auto_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/authentication/auth_page.dart';
import 'package:insthelper/screens/authentication/sign_in.dart';
import 'package:insthelper/screens/authentication/sign_up.dart';
import 'package:insthelper/screens/admin/container.dart';
import 'package:insthelper/screens/admin/add_vehicle.dart';
import 'package:insthelper/screens/admin/alert_list.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('vehicleDataBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomescreenProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
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
      debugShowCheckedModeBanner: false,
      routes: ({
        // Admin
        '/admin': (context) => const ContainerScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/auth': (context) => AuthPage(),
        '/add': (context) => AddVehicleScreen(),
        '/alert': (context) => const AlertList(),

        //User
        // '/user': (context) => const ContainerUserScreen(),
        // '/userAlert': (context) => const UserAlertList(),
      }),
      initialRoute: '/auth',
    );
  }
}
