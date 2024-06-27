import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/firebase_options.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/screens/container.dart';
import 'package:insthelper/screens/user/add_vehicle.dart';
import 'package:insthelper/screens/user/alert_list.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomescreenProvider(),
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
        '/': (context) => const ContainerScreen(),
        '/add': (context) => const AddVehicleScreen(),
        '/alert': (context) => const AlertList(),
      }),
      initialRoute: '/',
    );
  }
}
