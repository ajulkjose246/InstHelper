import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/firebase_options.dart';
import 'package:insthelper/screens/container.dart';
import 'package:insthelper/screens/user/add_vehicle.dart';
import 'package:insthelper/screens/user/vehicle_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: ({
        '/': (context) => ContainerScreen(),
        '/add': (context) => AddVehicleScreen(),
      }),
      initialRoute: '/',
    );
  }
}
