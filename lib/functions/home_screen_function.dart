import 'package:firebase_database/firebase_database.dart';

class HomeScreenFunction {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  Future<String> getModelImage(String modelName) async {
    String datas = '';
    try {
      final snapshot = await _databaseReference
          .child('Models')
          .child(modelName)
          .child('image')
          .get();
      // if (snapshot.exists) {
      datas = snapshot.value.toString();
      print(datas);
      // }
      // return null; // or handle error accordingly
    } catch (e) {
      print('Error fetching model image: $e');
    }
    return datas;
  }
}
