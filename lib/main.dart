import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/firebase_options.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/screens/authentication/auth_page.dart';
import 'package:insthelper/screens/authentication/sign_in.dart';
import 'package:insthelper/screens/authentication/sign_up.dart';
import 'package:insthelper/screens/admin/container.dart';
import 'package:insthelper/screens/admin/add_vehicle.dart';
import 'package:insthelper/screens/admin/alert_list.dart';
import 'package:insthelper/screens/user/alert_list.dart';
import 'package:insthelper/screens/user/container.dart';
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
        // Admin
        '/admin': (context) => const ContainerScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/auth': (context) => AuthPage(),
        '/add': (context) => const AddVehicleScreen(),
        '/alert': (context) => const AlertList(),

        //User
        '/user': (context) => const ContainerUserScreen(),
        '/userAlert': (context) => const UserAlertList(),
      }),
      initialRoute: '/auth',
    );
  }
}
