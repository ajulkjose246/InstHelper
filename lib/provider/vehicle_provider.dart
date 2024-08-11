// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insthelper/secrets/api_key.dart';

class VehicleProvider extends ChangeNotifier {
  final Uri url = Uri.parse(ApiKey().dbApiUrl);
  final Map<String, String> _headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> _vehicles = {};
  Map<String, dynamic> _specificVehicles = {};
  Map<String, dynamic> _vehicleModels = {};
  Map<String, dynamic> _vehicleFuel = {};
  Map<String, dynamic> _vehicleDrivers = {};
  Map<String, dynamic> _locations = {};

  Map<String, dynamic> get vehicles => _vehicles;
  Map<String, dynamic> get specificVehicles => _specificVehicles;
  Map<String, dynamic> get vehicleModels => _vehicleModels;
  Map<String, dynamic> get vehicleFuel => _vehicleFuel;
  Map<String, dynamic> get vehicleDrivers => _vehicleDrivers;
  Map<String, dynamic> get locations => _locations;

  Future<void> addVehicle(
    TextEditingController registrationNumberController,
    TextEditingController modelController,
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
    TextEditingController engineNoController,
    TextEditingController chassisNoController,
    List<String> uploadedImageNames,
    List<String> uploadedRcNames,
    List<String> uploadedFitnessNames,
    List<String> uploadedPollutionNames,
    List<String> uploadedInsuranceNames,
  ) async {
    List<String> sqlStatements = [];
    String formattedRegNumber =
        registrationNumberController.text.replaceAll(' ', '_').toUpperCase();
    sqlStatements.add(
        "INSERT INTO `tbl_vehicle`(`assigned_driver`, `chassis_no`, `current_mileage`, `emergency_contact`, `engine_no`, `fuel_type`, `model`, `ownership`, `purpose_of_use`, `registration_date`, `registration_number`, `vehicle_type`,`uploaded_files`) VALUES ('$drivers','${chassisNoController.text}','${currentMileageController.text}','${emergencyContactController.text}','${engineNoController.text}','$fuelType','${modelController.text}','${ownershipController.text}','${purposeOfUseController.text}','${registrationDateController.toIso8601String().split('T')[0]}','$formattedRegNumber','$vehicleType','${json.encode(uploadedRcNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_insurance`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${insuranceExpiryDate.toIso8601String().split('T')[0]}','${json.encode(uploadedInsuranceNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_fitness`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${fitnessUptoController.toIso8601String().split('T')[0]}','${json.encode(uploadedFitnessNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_pollution`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${pollutionUptoController.toIso8601String().split('T')[0]}','${json.encode(uploadedPollutionNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_vehicle_gallery`(`vehicle_id`, `image`) VALUES ('$formattedRegNumber','${json.encode(uploadedImageNames)}')");
    for (String sql in sqlStatements) {
      print(sql);

      final body = json.encode({
        'sql': sql,
      });

      try {
        final response = await http.put(url, headers: _headers, body: body);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print(responseData);
        } else {
          print(
              'Failed to update vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> deleteVehicle(String registrationNumber) async {
    List<String> sqlStatements = [];
    String formattedRegNumber =
        registrationNumber.replaceAll(' ', '_').toUpperCase();
    sqlStatements.add(
        "DELETE FROM `tbl_vehicle` WHERE `registration_number` ='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_fitness` WHERE `vehicle_id`='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_insurance` WHERE `vehicle_id`='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_pollution` WHERE `vehicle_id`='$formattedRegNumber'");
    for (String sql in sqlStatements) {
      print(sql);

      final body = json.encode({
        'sql': sql,
      });

      try {
        final response = await http.put(url, headers: _headers, body: body);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print(responseData);
        } else {
          print(
              'Failed to Delete vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> fetchVehicleData(String vehicleRegistrationId) async {
    final body = json.encode({
      'method': 'getSpecificVehicle',
      'vehicleRegistrationNo': vehicleRegistrationId,
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          print('Error: ${data['error']}');
        } else if (data is List<dynamic>) {
          _specificVehicles[vehicleRegistrationId] = data;
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchAllVehicleData() async {
    final body = json.encode({
      'method': 'getVehicle',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          print('Error: ${data['error']}');
        } else if (data is List<dynamic>) {
          _vehicles = {
            for (var item in data) item['registration_number']: item
          };
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateVehicleData(
    int type,
    String? vehicleRegistrationNo, [
    String? value1,
    String? value2,
    String? value3,
    String? value4,
    String? value5,
  ]) async {
    List<String> sqlStatements = [];

    switch (type) {
      case 1:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `ownership`='$value1' WHERE `registration_number`='$vehicleRegistrationNo'",
        );
        break;
      case 2:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `vehicle_type`='$value1',`model`='$value2',`fuel_type`='$value3',`engine_no`='$value4', `chassis_no`='$value5' WHERE `registration_number`='$vehicleRegistrationNo'",
        );
        break;
      case 3:
        if (value1 != null) {
          sqlStatements.add(
            "UPDATE `tbl_vehicle` SET `registration_date`='$value1' WHERE `registration_number`='$vehicleRegistrationNo'",
          );
        }
        if (value2 != null) {
          sqlStatements.add(
            "INSERT INTO `tbl_insurance`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value2')",
          );
        }
        if (value3 != null) {
          sqlStatements.add(
            "INSERT INTO `tbl_pollution`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value3')",
          );
        }
        if (value4 != null) {
          sqlStatements.add(
            "INSERT INTO `tbl_fitness`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value4')",
          );
        }
        break;
      case 4:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `purpose_of_use`='$value1',`emergency_contact`='$value2',`assigned_driver`='$value3' WHERE `registration_number` ='$vehicleRegistrationNo'",
        );
        break;
      default:
        print('Invalid type: $type');
        return;
    }

    for (String sql in sqlStatements) {
      print(sql);

      final body = json.encode({
        'sql': sql,
      });

      try {
        final response = await http.put(url, headers: _headers, body: body);

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('error')) {
            print('Error: ${responseData['error']}');
          } else if (responseData is Map<String, dynamic>) {
            print('Message: ${responseData['message']}');
            fetchAllVehicleData();
          } else {
            print('Unexpected data format: $responseData');
          }
        } else {
          print(
              'Failed to update vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    fetchVehicleData(vehicleRegistrationNo!);
  }

  Future<void> fetchModels() async {
    final body = json.encode({
      'method': 'getVehicleType',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            print('Error: ${data['error']}');
          } else {
            print('Unexpected data format: $data');
          }
        } else if (data is List<dynamic>) {
          _vehicleModels['vehicleTypes'] = data;
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchFuelType() async {
    final body = json.encode({
      'method': 'getFuel',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            print('Error: ${data['error']}');
          } else {
            print('Unexpected data format: $data');
          }
        } else if (data is List<dynamic>) {
          _vehicleFuel['vehicleFuel'] = data;
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchDrivers() async {
    final body = json.encode({
      'method': 'getDrivers',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            print('Error: ${data['error']}');
          } else {
            print('Unexpected data format: $data');
          }
        } else if (data is List<dynamic>) {
          _vehicleDrivers['vehicleDrivers'] = data;
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchLocation() async {
    final body = json.encode({
      'method': 'getLocations',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            print('Error: ${data['error']}');
          } else {
            print('Unexpected data format: $data');
          }
        } else if (data is List<dynamic>) {
          _locations['locations'] = data;
          if (hasListeners) {
            notifyListeners();
          }
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
