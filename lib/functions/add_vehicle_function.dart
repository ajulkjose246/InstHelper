// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddVehicleFunction {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  Future<List<String>> fetchModels() async {
    List<String> vehicleModels = [];
    try {
      final snapshot = await _databaseReference.child("Models").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('Name')) {
            vehicleModels.add(value['Name']);
          }
        });
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return vehicleModels;
  }

  Future<List<String>> fetchDrivers() async {
    List<String> drivers = [];
    try {
      final snapshot = await _databaseReference.child("Drivers").get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('Name')) {
            drivers.add(value['Name']);
          }
        });
      } else {
        print('No data available.');
      }
      print(drivers);
    } catch (error) {
      print('Error fetching data: $error');
    }
    return drivers;
  }

  Future<List<String>> fetchFuel() async {
    List<String> vehicleFuel = [];
    try {
      final snapshot = await _databaseReference.child("Fuels").get();
      if (snapshot.exists) {
        List<dynamic> fuelData = snapshot.value as List<dynamic>;
        for (var value in fuelData) {
          if (value != null) {
            vehicleFuel.add(value.toString());
          }
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return vehicleFuel;
  }

  void addVehicle(
    TextEditingController registrationNumberController,
    TextEditingController modelController,
    DateTime registrationDateController,
    String vehicleType,
    TextEditingController ownerNameController,
    TextEditingController ownershipController,
    String drivers,
    TextEditingController purposeOfUseController,
    DateTime insuranceExpiryDate,
    DateTime pollutionUptoController,
    DateTime fitnessUptoController,
    TextEditingController currentMileageController,
    String fuelType,
    TextEditingController emergencyContactController,
    TextEditingController engineNoController,
    TextEditingController chassisNoController,
    List<String> uploadedFileNames,
  ) {
    String formattedRegNumber =
        registrationNumberController.text.replaceAll(' ', '_').toUpperCase();

    _databaseReference.child("Vehicles").child(formattedRegNumber).set({
      "Registration Number": formattedRegNumber,
      "Model": modelController.text,
      "Engine No": engineNoController.text,
      "Chassis No": chassisNoController.text,
      "Registration Date": registrationDateController.toIso8601String(),
      "Vehicle Type": vehicleType,
      "Owner Name": ownerNameController.text,
      "Ownership": ownershipController.text,
      "Assigned Driver": drivers,
      "Purpose of Use": purposeOfUseController.text,
      "Insurance Upto": insuranceExpiryDate.toIso8601String(),
      "Pollution Upto": pollutionUptoController.toIso8601String(),
      "Fitness Upto": fitnessUptoController.toIso8601String(),
      "Current Mileage": currentMileageController.text,
      "Fuel Type": fuelType,
      "Emergency Contact": emergencyContactController.text,
      "Uploaded File Names": uploadedFileNames,
    });
  }
}
