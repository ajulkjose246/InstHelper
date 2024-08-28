// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TripProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tripData = [];
  List<Map<String, dynamic>> _tripSpecificData = [];

  List<Map<String, dynamic>> get tripData => _tripData;
  List<Map<String, dynamic>> get tripSpecificData => _tripSpecificData;
  final Uri url = Uri.parse('https://api.ajulkjose.in');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<void> addTrip(
    List<String> numbers,
    List<String> drivers,
    List<String> totalKm,
    List<String> additionalLocations,
    String tripPurpose,
    DateTime selectedDate,
    DateTime selectedEndDate,
  ) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
    String sql =
        "INSERT INTO `tbl_trips`(`vehicle_id`, `driver`, `purpose`, `ending_date`, `starting_date`, `route`, `starting_km`,`ending_km`) VALUES ('${json.encode(numbers)}','${json.encode(drivers)}','$tripPurpose','$formattedEndDate','$formattedDate','${json.encode(additionalLocations)}','${json.encode(totalKm)}','${json.encode(totalKm)}')";

    final body = json.encode({
      'sql': sql,
    });

    try {
      final response = await http.put(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        print('Trip added successfully');
      } else {
        print('Failed to update vehicle data. Status code: ${sql}');
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
        if (data is List<dynamic>) {
          _tripData = List<Map<String, dynamic>>.from(
            data.map((item) => Map<String, dynamic>.from(item)),
          );
          notifyListeners();
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

  Future<void> fetchSpecificTrip(int tripId) async {
    final body = json.encode({
      'method': 'getSpecificTrip',
      'tripId': tripId,
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List<dynamic>) {
          _tripSpecificData = List<Map<String, dynamic>>.from(
            data.map((item) => Map<String, dynamic>.from(item)),
          );
          print(_tripSpecificData);
          notifyListeners();
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

  Future<void> deleteTrip(String tripId) async {
    String sql = "DELETE FROM `tbl_trips` WHERE `id` =$tripId";

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

  @override
  void dispose() {
    super.dispose();
  }
}
