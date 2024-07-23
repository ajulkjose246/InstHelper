// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class GetDept {
  Future<void> getData() async {
    final url = Uri.parse('https://api.ajulkjose.in');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'method': 'getVehicle',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
