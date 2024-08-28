import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insthelper/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20 / textScaleFactor),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50 / textScaleFactor,
                          backgroundImage: AssetImage('assets/img/demo.jpg'),
                        ),
                        SizedBox(height: 10 / textScaleFactor),
                        Text(
                          "Ajul K Jose",
                          style: TextStyle(
                            fontSize: 20 / textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(15 / textScaleFactor),
                    padding: EdgeInsets.all(10 / textScaleFactor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 16 / textScaleFactor,
                            color: theme.colorScheme.inversePrimary,
                          ),
                        ),
                        Switch(
                          activeColor: theme.colorScheme.primary,
                          value: context.watch<ThemeProvider>().isDarkMode,
                          onChanged: (value) {
                            context.read<ThemeProvider>().setThemeMode(value);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16 / textScaleFactor),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    GoogleSignIn().signOut();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16 / textScaleFactor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
