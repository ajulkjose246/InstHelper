import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart'; // Add provider import
import 'package:AjceTrips/provider/vehicle_provider.dart'; // Import VehicleProvider
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast

class AuthService {
  signInWithGoogle(BuildContext context) async {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);

    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        print('Google sign-in aborted by user');
        return;
      }

      final GoogleSignInAuthentication? gAuth = await gUser.authentication;
      if (gAuth == null) {
        print('Google authentication failed');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String status = userDoc['status'];
          String role = userDoc['role'];
          if (status != 'active') {
            // Show inactive user message
            Fluttertoast.showToast(
              msg: 'You do not have permission to access the app.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            // Sign out the user from Firebase and Google if status is not active
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          } else {
            // Fetch drivers list
            await vehicleProvider.fetchDrivers();
            final driversList =
                vehicleProvider.vehicleDrivers['vehicleDrivers'] ?? [];

            // Check if the user's email is in the drivers list
            bool isDriver =
                driversList.any((driver) => driver['email'] == user.email);

            if (isDriver && role != 'driver') {
              // Update role to driver if the user is now a driver
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'role': 'driver'});
            } else if (!isDriver && role == 'driver') {
              // Update role to user if the user is no longer a driver
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'role': 'user'});
            }
          }
        } else {
          // Create Firestore entry if user document does not exist
          String role = 'user'; // Default role
          String status = 'inactive'; // Default status

          // Fetch drivers list
          await vehicleProvider.fetchDrivers();
          final driversList =
              vehicleProvider.vehicleDrivers['vehicleDrivers'] ?? [];

          // Check if the user's email is in the drivers list
          bool isDriver =
              driversList.any((driver) => driver['email'] == user.email);

          if (isDriver) {
            role = 'driver';
            status = 'active';
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': user.displayName,
            'email': user.email,
            'status': status, // Example status
            'role': role,
          });
        }
      }

      return userCredential;
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('An error occurred during Google sign-in: ${e.message}')),
      );
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String status = userDoc['status'];
          String role = userDoc['role'];
          if (status != 'active') {
            // Show inactive user message
            Fluttertoast.showToast(
              msg: 'You do not have permission to access the app.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
            );
            // Sign out the user from Firebase if status is not active
            await FirebaseAuth.instance.signOut();
          } else {
            // Fetch drivers list
            await vehicleProvider.fetchDrivers();
            final driversList =
                vehicleProvider.vehicleDrivers['vehicleDrivers'] ?? [];

            // Check if the user's email is in the drivers list
            bool isDriver =
                driversList.any((driver) => driver['email'] == user.email);

            if (isDriver && role != 'driver') {
              // Update role to driver if the user is now a driver
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'role': 'driver'});
            } else if (!isDriver && role == 'driver') {
              // Update role to user if the user is no longer a driver
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'role': 'user'});
            }
          }
        } else {
          // Create Firestore entry if user document does not exist
          String role = 'user'; // Default role
          String status = 'inactive'; // Default status

          // Fetch drivers list
          await vehicleProvider.fetchDrivers();
          final driversList =
              vehicleProvider.vehicleDrivers['vehicleDrivers'] ?? [];

          // Check if the user's email is in the drivers list
          bool isDriver =
              driversList.any((driver) => driver['email'] == user.email);

          if (isDriver) {
            role = 'driver';
            status = 'active';
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': user.displayName,
            'email': user.email,
            'status': status, // Example status
            'role': role,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<void> signInAsAdmin(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role != 'admin') {
            // Sign out the user from Firebase if role is not admin
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You do not have admin privileges')),
            );
          }
        } else {
          // Sign out the user from Firebase if user document does not exist
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User does not exist')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }
}
