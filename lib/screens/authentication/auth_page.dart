import 'package:AjceTrips/screens/normal/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AjceTrips/screens/authentication/sign_in.dart';
import 'package:AjceTrips/screens/admin/container.dart';
import 'package:AjceTrips/screens/driver/container.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart'; // Import the VehicleProvider
import 'package:provider/provider.dart'; // Import provider package
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> isDriver(String email, BuildContext context) async {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    await vehicleProvider.fetchDrivers();
    final drivers =
        vehicleProvider.vehicleDrivers['vehicleDrivers'] as List<dynamic>;
    return drivers.any((driver) => driver['email'] == email);
  }

  Future<bool> isActiveUser(String email, String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists && userDoc.data()?['status'] == 'active';
  }

  Future<String?> getUserRole(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()?['role'];
    }
    return null;
  }

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

            return FutureBuilder<bool>(
              future: isActiveUser(email, user?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  return FutureBuilder<bool>(
                    future: isDriver(email, context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data == true) {
                        return DriverContainerScreen(); // Navigate to the new driver home screen
                      } else {
                        return FutureBuilder<String?>(
                          future: getUserRole(user?.uid ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data == 'admin') {
                              return ContainerScreen(); // Navigate to the admin home screen
                            } else {
                              return const NormalContainerScreen();
                            }
                          },
                        );
                      }
                    },
                  );
                } else {
                  return const SignInScreen(); // User is inactive
                }
              },
            );
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
