// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripProvider extends ChangeNotifier {
  Map<String, dynamic> _tripData = {};

  Map<String, dynamic> get tripData => _tripData;
  final Uri url = Uri.parse('https://api.ajulkjose.in');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<void> addTrip(
    String registrationNumber,
    TextEditingController startingTimeController,
    int startPoint,
    int endPoint,
  ) async {
    String sql =
        "INSERT INTO `tbl_trips`(`vehicle_id`, `starting_time`, `start_point`, `end_point`) VALUES ('$registrationNumber','${startingTimeController.text}',$startPoint,$endPoint)";

    final body = json.encode({
      'sql': sql,
    });

    try {
      final response = await http.put(url, headers: _headers, body: body);
      print(response);
      print(sql);
      if (response.statusCode == 200) {
        fetchTrip();
      } else {
        print(
            'Failed to update vehicle data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchTrip() async {
    final body = json.encode({
      'method': 'getTrips',
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
          _tripData['tripData'] = data;
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
