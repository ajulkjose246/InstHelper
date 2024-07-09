// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateVehicleFunction {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  void updateVehicleOwnerDetails(
      TextEditingController ownershipController, String formattedRegNumber) {
    _databaseReference.child("Vehicles").child(formattedRegNumber).update(
      {
        "Owner Name": ownershipController.text,
      },
    );
  }

  void updateVehicleDetails(
      TextEditingController vehicleType,
      TextEditingController model,
      TextEditingController fuelType,
      TextEditingController engineNo,
      TextEditingController chassisNo,
      String formattedRegNumber) {
    _databaseReference.child("Vehicles").child(formattedRegNumber).update(
      {
        "Chassis No": chassisNo.text,
        "Engine No": engineNo.text,
        "Fuel Type": fuelType.text,
        "Model": model.text,
        "Vehicle Type": vehicleType.text,
      },
    );
  }

  void updateVehicle(
    String formattedRegNumber,
    TextEditingController modelController,
    TextEditingController engineNoController,
    TextEditingController chassisNoController,
    DateTime registrationDateController,
    String vehicleType,
    TextEditingController ownershipController,
    String drivers,
    TextEditingController purposeOfUseController,
    DateTime insuranceExpiryDate,
    DateTime pollutionUptoController,
    DateTime fitnessUptoController,
    TextEditingController currentMileageController,
    String fuelType,
    TextEditingController emergencyContactController,
    List<String> uploadedFileNames,
  ) {
    DateTime currentDate = DateTime.now();
    int timestamp = currentDate.millisecondsSinceEpoch;

    _databaseReference.child("Vehicles").child(formattedRegNumber).update({
      "Model": modelController.text,
      "Engine No": engineNoController.text,
      "Chassis No": chassisNoController.text,
      "Registration Date":
          registrationDateController.toIso8601String().split('T')[0],
      "Vehicle Type": vehicleType,
      "Ownership": ownershipController.text,
      "Assigned Driver": drivers,
      "Purpose of Use": purposeOfUseController.text,
      "Insurance Upto": insuranceExpiryDate.toIso8601String().split('T')[0],
      "Fitness Upto": fitnessUptoController.toIso8601String().split('T')[0],
      "Pollution Upto": pollutionUptoController.toIso8601String().split('T')[0],
      "Current Mileage": currentMileageController.text,
      "Fuel Type": fuelType,
      "Emergency Contact": emergencyContactController.text,
      "Uploaded File Names": uploadedFileNames,
    });

    _databaseReference
        .child("Insurance")
        .child(formattedRegNumber)
        .set({timestamp: insuranceExpiryDate.toIso8601String().split('T')[0]});
    _databaseReference.child("Pollution").child(formattedRegNumber).set(
        {timestamp: pollutionUptoController.toIso8601String().split('T')[0]});
    _databaseReference.child("Fitness").child(formattedRegNumber).set(
        {timestamp: fitnessUptoController.toIso8601String().split('T')[0]});
  }
}
