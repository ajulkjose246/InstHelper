import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:AjceTrips/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userRole = userDoc.data()?['role'] ?? 'Unknown';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20 / textScaleFactor),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.inversePrimary,
                        radius: 50 / textScaleFactor,
                        backgroundImage: AssetImage('assets/img/user.png'),
                      ),
                      SizedBox(height: 10 / textScaleFactor),
                      Text(
                        FirebaseAuth.instance.currentUser?.displayName ??
                            FirebaseAuth.instance.currentUser?.email ??
                            "Admin",
                        style: TextStyle(
                          fontSize: 20 / textScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        "${userRole ?? 'Loading...'}",
                        style: TextStyle(
                          fontSize: 14 / textScaleFactor,
                          color: theme.colorScheme.primary,
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
            Positioned(
              top: 16 / textScaleFactor,
              right: 16 / textScaleFactor,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.power_settings_new,
                      color: theme.colorScheme.error),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    final googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
