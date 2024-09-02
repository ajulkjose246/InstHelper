// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:AjceTrips/secrets/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TripProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tripData = [];
  List<Map<String, dynamic>> _tripSpecificData = [];

  List<Map<String, dynamic>> get tripData => _tripData;
  List<Map<String, dynamic>> get tripSpecificData => _tripSpecificData;
  final Uri url = Uri.parse(ApiKey().dbApiUrl);
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<void> addTrip(
    List<String> numbers,
    List<String> drivers,
    List<String> currentKM,
    List<String> additionalLocations,
    String tripPurpose,
    DateTime selectedDate,
    DateTime selectedEndDate,
  ) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
    String sql =
        "INSERT INTO `tbl_trips`(`vehicle_id`, `driver`, `purpose`, `ending_date`, `starting_date`, `route`, `starting_km`,`ending_km`) VALUES ('${json.encode(numbers)}','${json.encode(drivers)}','$tripPurpose','$formattedEndDate','$formattedDate','${json.encode(additionalLocations)}','${json.encode(currentKM)}','${json.encode(currentKM)}')";

    final body = json.encode({
      'sql': sql,
    });

    try {
      final response = await http.put(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        print('Trip added successfully');

        // Update total_km for each vehicle
        for (int i = 0; i < numbers.length; i++) {
          String vehicleSql = '''
            UPDATE tbl_vehicle
            SET total_km = total_km + ${currentKM[i]}
            WHERE registration_number = "${numbers[i]}"
          ''';

          final vehicleBody = json.encode({'sql': vehicleSql});
          final vehicleResponse =
              await http.put(url, headers: _headers, body: vehicleBody);

          if (vehicleResponse.statusCode == 200) {
            print('Vehicle ${numbers[i]} total_km updated successfully');
          } else {
            print(
                'Failed to update vehicle ${numbers[i]} total_km. Status code: ${vehicleResponse.statusCode}');
          }
        }
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

  Future<void> updateTripData(
      int type, int tripId, Map<String, dynamic> updatedData) async {
    String tripSql = '';
    String vehicleSql = '';

    switch (type) {
      case 1:
        List<String> tripUpdates = [];
        if (updatedData['purpose'] != null) {
          tripUpdates.add("purpose = '${updatedData['purpose']}'");
        }
        if (updatedData['starting_date'] != null) {
          tripUpdates.add("starting_date = '${updatedData['starting_date']}'");
        }
        if (updatedData['ending_date'] != null) {
          tripUpdates.add("ending_date = '${updatedData['ending_date']}'");
        }

        if (tripUpdates.isNotEmpty) {
          tripSql = '''
            UPDATE tbl_trips 
            SET ${tripUpdates.join(', ')}
            WHERE id = $tripId
          ''';
        }
        break;
      case 2:
        List<String> vehicleUpdates = [];
        if (updatedData['vehicle_id'] != null) {
          vehicleUpdates
              .add("vehicle_id = '${json.encode(updatedData['vehicle_id'])}'");
        }
        if (updatedData['driver'] != null) {
          vehicleUpdates
              .add("driver = '${json.encode(updatedData['driver'])}'");
        }
        if (updatedData['starting_km'] != null) {
          vehicleUpdates.add(
              "starting_km = '${json.encode(updatedData['starting_km'])}'");
        }
        if (updatedData['ending_km'] != null) {
          vehicleUpdates
              .add("ending_km = '${json.encode(updatedData['ending_km'])}'");
        }

        if (vehicleUpdates.isNotEmpty) {
          tripSql = '''
            UPDATE tbl_trips 
            SET ${vehicleUpdates.join(', ')}
            WHERE id = $tripId
          ''';
        }

        if (updatedData['ending_km'] != null &&
            updatedData['starting_km'] != null) {
          vehicleSql = '''
            UPDATE tbl_vehicle
            SET total_km = total_km + (
              ${updatedData['ending_km'][0]} - ${updatedData['starting_km'][0]}
            )
            WHERE registration_number = "${updatedData['vehicle_id'][0]}"
          ''';
        }
        break;
      case 3:
        if (updatedData['route'] != null) {
          tripSql = '''
            UPDATE tbl_trips 
            SET route = '${json.encode(updatedData['route'])}'
            WHERE id = $tripId
          ''';
        }
        break;
      default:
        print('Invalid update type');
        return;
    }

    try {
      // Execute trip update
      if (tripSql.isNotEmpty) {
        print('Executing trip SQL: $tripSql'); // Debug print
        final tripBody = json.encode({'sql': tripSql});
        final tripResponse =
            await http.put(url, headers: _headers, body: tripBody);

        if (tripResponse.statusCode == 200) {
          print('Trip updated successfully');
        } else {
          print(
              'Failed to update trip data. Status code: ${tripResponse.statusCode}');
        }
      }

      // Execute vehicle update if applicable
      if (vehicleSql.isNotEmpty) {
        print('Executing vehicle SQL: $vehicleSql'); // Debug print
        final vehicleBody = json.encode({'sql': vehicleSql});
        final vehicleResponse =
            await http.put(url, headers: _headers, body: vehicleBody);

        if (vehicleResponse.statusCode == 200) {
          print('Vehicle total_km updated successfully');
        } else {
          print(
              'Failed to update vehicle total_km. Status code: ${vehicleResponse.statusCode}');
        }
      }

      await fetchSpecificTrip(tripId);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
