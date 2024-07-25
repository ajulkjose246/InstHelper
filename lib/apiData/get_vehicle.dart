// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insthelper/hive/vehicle_curd_oprtations.dart';

class GetVehicle {
  final url = Uri.parse('https://api.ajulkjose.in');
  final headers = {'Content-Type': 'application/json'};
  Future<void> fetchVehicleData() async {
    final body = json.encode({
      'method': 'getVehicle',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        VehicleCurdOprtations().insertVehicle(data);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchVehicleImage() async {
    final body = json.encode({
      'method': 'getVehicleImage',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        VehicleCurdOprtations().insertVehicleImage(data);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
