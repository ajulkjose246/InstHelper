import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VehicleProvider extends ChangeNotifier {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");
  Map<String, dynamic> _vehicles = {};
  String rtoName = '';

  Map<String, dynamic> get vehicles => _vehicles;

  Future<void> fetchVehicleData(String vehicleRegistrationNo) async {
    try {
      final snapshot = await _databaseReference
          .child('Vehicles')
          .child(vehicleRegistrationNo)
          .get();

      if (snapshot.exists && snapshot.value != null) {
        _vehicles[vehicleRegistrationNo] =
            Map<String, dynamic>.from(snapshot.value as Map);
        notifyListeners();
        fetchRTO(vehicleRegistrationNo);
      }
    } catch (e) {
      print('Error fetching model image: $e');
    }
  }

  Future<void> fetchRTO(String vehicleRegistrationNo) async {
    try {
      List<String> parts = vehicleRegistrationNo.split('_');
      String extractedNumber = '';
      if (parts.length >= 2) {
        extractedNumber = parts[1];
      } else {
        print('Invalid format');
      }
      final snapshot = await _databaseReference
          .child("RTO")
          .child('KL-$extractedNumber')
          .get();
      if (snapshot.exists) {
        rtoName = snapshot.value.toString();
        notifyListeners();
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
