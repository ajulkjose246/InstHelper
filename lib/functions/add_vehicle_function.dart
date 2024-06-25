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

  void addVehicle(
    TextEditingController registrationNumberController,
    TextEditingController modelController,
    TextEditingController registrationDateController,
    String vehicleType,
    TextEditingController ownerNameController,
    TextEditingController ownershipController,
    TextEditingController assignedDriverController,
    TextEditingController purposeOfUseController,
    DateTime insuranceExpiryDate,
    TextEditingController pollutionUptoController,
    TextEditingController fitnessUptoController,
    TextEditingController currentMileageController,
    TextEditingController fuelTypeController,
    TextEditingController emergencyContactController,
    TextEditingController engineNoController,
    TextEditingController chassisNoController,
    String uploadedFileName,
  ) {
    String formattedRegNumber =
        registrationNumberController.text.replaceAll(' ', '_').toUpperCase();

    _databaseReference.child("Vehicles").child(formattedRegNumber).set({
      "Registration Number": formattedRegNumber,
      "Model": modelController.text,
      "Engine No": engineNoController.text,
      "Chassis No": chassisNoController.text,
      "Registration Date": registrationDateController.text,
      "Vehicle Type": vehicleType,
      "Owner Name": ownerNameController.text,
      "Ownership": ownershipController.text,
      "Assigned Driver": assignedDriverController.text,
      "Purpose of Use": purposeOfUseController.text,
      "Insurance Upto": insuranceExpiryDate.toString(),
      "Pollution Upto": pollutionUptoController.text,
      "Fitness Upto": fitnessUptoController.text,
      "Current Mileage": currentMileageController.text,
      "Fuel Type": fuelTypeController.text,
      "Emergency Contact": emergencyContactController.text,
      "Uploaded File Name": uploadedFileName,
    });
  }
}
