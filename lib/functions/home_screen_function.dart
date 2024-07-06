// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';

class HomeScreenFunction {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  Future<String> getModelImage(String modelName) async {
    try {
      final snapshot = await _databaseReference
          .child('Models')
          .child(modelName)
          .child('image')
          .get();
      return snapshot.value.toString();
    } catch (e) {
      print('Error fetching model image: $e');
      return '';
    }
  }

  Future<DateTime?> getLatestDueDate(String modelName, String type) async {
    try {
      final snapshot = await FirebaseDatabase.instance
          .ref("Vehicle-Management")
          .child("Vehicles")
          .child(modelName)
          .child(type)
          .get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        // Convert keys to DateTime and sort them
        List<int> timestamps = data.keys.map((key) => int.parse(key)).toList();
        timestamps.sort();

        // Get the latest timestamp
        int latestTimestamp = timestamps.last;
        DateTime latestValue =
            DateTime.fromMillisecondsSinceEpoch(latestTimestamp);

        // Return the latest value
        return latestValue;
      } else {
        print('No data available.');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
