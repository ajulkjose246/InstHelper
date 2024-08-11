import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/screens/authentication/sign_in.dart';
import 'package:insthelper/screens/admin/container.dart';
import 'package:insthelper/screens/driver/container.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;

            // Check if the user is not null and has a display name
            String email = user?.email ?? 'No email';
            if (email == "mail.ajulkjose@gmail.com") {
              return ContainerScreen();
            } else {
              return const DriverContainerScreen();
            }
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
