import 'package:flutter/material.dart';
import 'package:insthelper/screens/container.dart';

void main() {
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
      }),
      initialRoute: '/',
    );
  }
}
