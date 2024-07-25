// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleProvider extends ChangeNotifier {
  final Uri url = Uri.parse('https://api.ajulkjose.in');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> _vehicles = {};
  String rtoName = '';

  Map<String, dynamic> get vehicles => _vehicles;

  Future<void> fetchVehicleData(String vehicleRegistrationId) async {
    print(vehicleRegistrationId);
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
          _vehicles[vehicleRegistrationId] = data;
          if (hasListeners) {
            notifyListeners();
          }
          fetchRTO(vehicleRegistrationId);
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
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

    if (type == 1) {
      sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `ownership`='$value1' WHERE `id`='$vehicleRegistrationNo'");
    } else if (type == 2) {
      sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `vehicle_type`='$value1',`model`='$value2',`fuel_type`='$value3',`engine_no`='$value4', `chassis_no`='$value5' WHERE `id`='$vehicleRegistrationNo'");
    } else if (type == 3) {
      if (value1 != null) {
        sqlStatements.add(
            "UPDATE `tbl_vehicle` SET `registration_date`='$value1' WHERE `id`='$vehicleRegistrationNo'");
      }
      if (value2 != null) {
        sqlStatements.add(
            "INSERT INTO `tbl_insurance`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value2')");
      }
      if (value3 != null) {
        sqlStatements.add(
            "INSERT INTO `tbl_pollution`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value3')");
      }
      if (value4 != null) {
        sqlStatements.add(
            "INSERT INTO `tbl_fitness`(`vehicle_id`, `exp_date`) VALUES ('$vehicleRegistrationNo','$value4')");
      }
    } else if (type == 4) {
      sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `purpose_of_use`='$value1',`emergency_contact`='$value2',`assigned_driver`='$value3' WHERE `id` ='$vehicleRegistrationNo'");
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
          } else {
            print('Unexpected data format: $responseData');
          }
        } else {
          throw Exception(
              'Failed to update vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Error: $e');
      }
    }

    fetchVehicleData(vehicleRegistrationNo!);
  }

  Future<void> fetchRTO(String vehicleRegistrationNo) async {
    // Implement this function based on your requirements
  }

  @override
  void dispose() {
    // Custom dispose logic if needed
    super.dispose();
  }
}
