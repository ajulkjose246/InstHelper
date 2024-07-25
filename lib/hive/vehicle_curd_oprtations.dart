import 'package:hive/hive.dart';

class VehicleCurdOprtations {
  final _vehicleDataBox = Hive.box('vehicleDataBox');

  Future<void> insertVehicle(List<dynamic> vehicleData) async {
    _vehicleDataBox.put('vehicle', vehicleData);
  }

  Future<void> insertVehicleImage(List<dynamic> vehicleData) async {
    _vehicleDataBox.put('vehicleImage', vehicleData);
  }

  List<dynamic> readVehicle() {
    final rawData = _vehicleDataBox.get('vehicle', defaultValue: {});
    return rawData;
  }

  List<dynamic> readVehicleImage() {
    final rawData = _vehicleDataBox.get('vehicleImage', defaultValue: {});
    return rawData;
  }
}
