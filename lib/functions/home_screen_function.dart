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
}
