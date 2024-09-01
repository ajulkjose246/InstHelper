import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:AjceTrips/secrets/api_key.dart';

class MapAuto with ChangeNotifier {
  List<Map<String, dynamic>> _predictions = [];

  List<Map<String, dynamic>> get predictions => _predictions;

  Future<void> placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "/maps/api/place/autocomplete/json", {
      "input": query,
      "key": ApiKey().gMapApiKey,
    });
    try {
      String? response = await fetchUrl(uri);
      if (response != null) {
        _predictions = extractPredictions(response);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final String apiKey = ApiKey().gMapApiKey;
    final Uri uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/details/json",
      {
        "place_id": placeId,
        "key": apiKey,
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['result'];
        final location = result['geometry']['location'];
        return {
          'lat': location['lat'],
          'lng': location['lng'],
        };
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
    return null;
  }

  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print("Error fetching url: $e");
    }
    return null;
  }

  List<Map<String, dynamic>> extractPredictions(String responseBody) {
    var jsonResponse = json.decode(responseBody);
    var predictions = jsonResponse['predictions'] as List;
    return predictions
        .map((prediction) => prediction as Map<String, dynamic>)
        .toList();
  }
}
