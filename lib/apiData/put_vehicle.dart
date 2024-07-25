// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insthelper/apiData/get_vehicle.dart';

class PutVehicle {
  final url = Uri.parse('https://api.ajulkjose.in');
  final headers = {'Content-Type': 'application/json'};
  Future<void> updateVehicleData() async {
    String name = "AMAL";
    int id = 1;
    final body = json.encode({
      'sql': "UPDATE `tbl_vehicle` SET `ownership`='$name' WHERE `id` =$id",
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          print('Error: ${responseData['error']}');
        } else {
          print('Message: ${responseData['message']}');
          GetVehicle().fetchVehicleData();
        }
      } else {
        print('Failed to update user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
