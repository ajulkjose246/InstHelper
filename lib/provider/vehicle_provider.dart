// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:AjceTrips/secrets/api_key.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class VehicleProvider extends ChangeNotifier {
  final Uri url = Uri.parse(ApiKey().dbApiUrl);
  final Map<String, String> _headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> _vehicles = {};
  final Map<String, dynamic> _specificVehicles = {};
  final Map<String, dynamic> _vehicleModels = {};
  final Map<String, dynamic> _vehicleFuel = {};
  final Map<String, dynamic> _vehicleDrivers = {};
  final Map<String, dynamic> _locations = {};

  Map<String, dynamic> get vehicles => _vehicles;
  Map<String, dynamic> get specificVehicles => _specificVehicles;
  Map<String, dynamic> get vehicleModels => _vehicleModels;
  Map<String, dynamic> get vehicleFuel => _vehicleFuel;
  Map<String, dynamic> get vehicleDrivers => _vehicleDrivers;
  Map<String, dynamic> get locations => _locations;

  Future<void> addVehicle(
    TextEditingController registrationNumberController,
    TextEditingController modelController,
    DateTime registrationDateController,
    String vehicleType,
    TextEditingController ownershipController,
    TextEditingController purposeOfUseController,
    DateTime insuranceExpiryDate,
    DateTime pollutionUptoController,
    DateTime fitnessUptoController,
    TextEditingController currentKMController,
    String fuelType,
    TextEditingController engineNoController,
    TextEditingController chassisNoController,
    List<String> uploadedImageNames,
    List<String> uploadedRcNames,
    List<String> uploadedFitnessNames,
    List<String> uploadedPollutionNames,
    List<String> uploadedInsuranceNames,
  ) async {
    List<String> sqlStatements = [];
    String formattedRegNumber =
        registrationNumberController.text.replaceAll(' ', '_').toUpperCase();
    sqlStatements.add(
        "INSERT INTO `tbl_vehicle`( `chassis_no`, `total_km`, `engine_no`, `fuel_type`, `model`, `ownership`, `purpose_of_use`, `registration_date`, `registration_number`, `vehicle_type`,`uploaded_files`) VALUES ('${chassisNoController.text}','${currentKMController.text}','${engineNoController.text}','$fuelType','${modelController.text}','${ownershipController.text}','${purposeOfUseController.text}','${registrationDateController.toIso8601String().split('T')[0]}','$formattedRegNumber','$vehicleType','${json.encode(uploadedRcNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_insurance`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${insuranceExpiryDate.toIso8601String().split('T')[0]}','${json.encode(uploadedInsuranceNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_fitness`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${fitnessUptoController.toIso8601String().split('T')[0]}','${json.encode(uploadedFitnessNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_pollution`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$formattedRegNumber','${pollutionUptoController.toIso8601String().split('T')[0]}','${json.encode(uploadedPollutionNames)}')");
    sqlStatements.add(
        "INSERT INTO `tbl_vehicle_gallery`(`vehicle_id`, `image`) VALUES ('$formattedRegNumber','${json.encode(uploadedImageNames)}')");
    for (String sql in sqlStatements) {
      print(sql);

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
              'Failed to update vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> deleteVehicle(String registrationNumber) async {
    List<String> sqlStatements = [];
    String formattedRegNumber =
        registrationNumber.replaceAll(' ', '_').toUpperCase();
    sqlStatements.add(
        "DELETE FROM `tbl_vehicle` WHERE `registration_number` ='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_fitness` WHERE `vehicle_id`='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_insurance` WHERE `vehicle_id`='$formattedRegNumber'");
    sqlStatements.add(
        "DELETE FROM `tbl_pollution` WHERE `vehicle_id`='$formattedRegNumber'");
    for (String sql in sqlStatements) {
      print(sql);

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
  }

  Future<void> fetchVehicleData(String vehicleRegistrationId) async {
    final body = json.encode({
      'method': 'getSpecificVehicle',
      'vehicleRegistrationNo': vehicleRegistrationId,
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          print('Error: ${data['error']}');
        } else if (data is List<dynamic>) {
          _specificVehicles[vehicleRegistrationId] = data;
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

  Future<void> fetchAllVehicleData() async {
    final body = json.encode({
      'method': 'getVehicle',
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          print('Error: ${data['error']}');
        } else if (data is List<dynamic>) {
          _vehicles = {
            for (var item in data) item['registration_number']: item
          };
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

  Future<void> updateVehicleData(
    int type,
    String vehicleRegistrationNo, [
    String? value1,
    String? value2,
    String? value3,
    String? value4,
    String? value5,
    Map<String, List<File>>? selectedImages,
    List<File>? newGalleryImages,
  ]) async {
    List<String> sqlStatements = [];
    Map<String, List<String>> uploadedFileUrls = {
      'registration': [],
      'insurance': [],
      'pollution': [],
      'fitness': [],
      'gallery': [],
    };

    // Upload images to Firebase Storage
    if (selectedImages != null) {
      for (var entry in selectedImages.entries) {
        String dateType = entry.key;
        List<File> images = entry.value;

        for (var image in images) {
          String fileName = path.basename(image.path);
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('Vehicle_Documents')
              .child(vehicleRegistrationNo)
              .child(dateType)
              .child(fileName);

          try {
            await ref.putFile(image);
            String fileUrl = await ref.getDownloadURL();
            uploadedFileUrls[dateType]!.add(fileUrl);
          } catch (e) {
            print("Failed to upload file: $e");
          }
        }
      }
    }

    // Upload new gallery images
    if (newGalleryImages != null && newGalleryImages.isNotEmpty) {
      for (var image in newGalleryImages) {
        String fileName = path.basename(image.path);
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('Vehicle_Documents')
            .child(vehicleRegistrationNo)
            .child('gallery')
            .child(fileName);

        try {
          await ref.putFile(image);
          String fileUrl = await ref.getDownloadURL();
          uploadedFileUrls['gallery']!.add(fileUrl);
        } catch (e) {
          print("Failed to upload gallery image: $e");
        }
      }
    }

    switch (type) {
      case 1:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `ownership`='$value1' WHERE `registration_number`='$vehicleRegistrationNo'",
        );
        break;
      case 2:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `vehicle_type`='$value1',`model`='$value2',`fuel_type`='$value3',`engine_no`='$value4', `chassis_no`='$value5' WHERE `registration_number`='$vehicleRegistrationNo'",
        );
        break;
      case 3:
        if (value1 != null) {
          sqlStatements.add(
            "UPDATE `tbl_vehicle` SET `registration_date`='$value1' WHERE `registration_number`='$vehicleRegistrationNo'",
          );
          if (uploadedFileUrls['registration']!.isNotEmpty) {
            String jsonUrls = json.encode(uploadedFileUrls['registration']);
            sqlStatements.add(
              "UPDATE `tbl_vehicle` SET `uploaded_files`='$jsonUrls' WHERE `registration_number`='$vehicleRegistrationNo'",
            );
          }
        }
        if (value2 != null) {
          String jsonUrls = json.encode(uploadedFileUrls['insurance']);
          sqlStatements.add(
            "INSERT INTO `tbl_insurance`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$vehicleRegistrationNo','$value2','$jsonUrls') ON DUPLICATE KEY UPDATE `exp_date`='$value2', `documents`='$jsonUrls'",
          );
        }
        if (value3 != null) {
          String jsonUrls = json.encode(uploadedFileUrls['pollution']);
          sqlStatements.add(
            "INSERT INTO `tbl_pollution`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$vehicleRegistrationNo','$value3','$jsonUrls') ON DUPLICATE KEY UPDATE `exp_date`='$value3', `documents`='$jsonUrls'",
          );
        }
        if (value4 != null) {
          String jsonUrls = json.encode(uploadedFileUrls['fitness']);
          sqlStatements.add(
            "INSERT INTO `tbl_fitness`(`vehicle_id`, `exp_date`, `documents`) VALUES ('$vehicleRegistrationNo','$value4','$jsonUrls') ON DUPLICATE KEY UPDATE `exp_date`='$value4', `documents`='$jsonUrls'",
          );
        }
        break;
      case 4:
        sqlStatements.add(
          "UPDATE `tbl_vehicle` SET `purpose_of_use`='$value1' WHERE `registration_number` ='$vehicleRegistrationNo'",
        );
        break;
      case 5:
        if (uploadedFileUrls['gallery']!.isNotEmpty) {
          String jsonUrls = json.encode(uploadedFileUrls['gallery']);
          sqlStatements.add(
            "UPDATE `tbl_vehicle_gallery` SET `image` = '$jsonUrls' WHERE `vehicle_id` = '$vehicleRegistrationNo'",
          );
        }
        break;
    }

    // Execute SQL statements
    for (String sql in sqlStatements) {
      print(sql);

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
              'Failed to update vehicle data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    // Fetch updated vehicle data
    await fetchVehicleData(vehicleRegistrationNo);
  }

  Future<void> fetchModels() async {
    final body = json.encode({
      'method': 'getVehicleType',
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
          _vehicleModels['vehicleTypes'] = data;
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

  Future<void> fetchFuelType() async {
    final body = json.encode({
      'method': 'getFuel',
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
          _vehicleFuel['vehicleFuel'] = data;
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

  Future<void> fetchDrivers() async {
    final body = json.encode({
      'method': 'getDrivers',
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
          _vehicleDrivers['vehicleDrivers'] = data;
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

  Future<void> fetchLocation() async {
    final body = json.encode({
      'method': 'getLocations',
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
          _locations['locations'] = data;
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

  Future<void> addDriver({
    required String name,
    required String phoneNumber,
    required String email,
    required String licenseNumber,
    required File licenseImage,
  }) async {
    try {
      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToFirebase(licenseImage);

      // Prepare SQL statement to insert driver details
      String sql = '''
        INSERT INTO `tbl_drivers` (
          `name`, 
          `phone_number`, 
          `email`, 
          `license_number`, 
          `license_image_url`
        ) VALUES (
          '$name',
          '$phoneNumber',
          '$email',
          '$licenseNumber',
          '$imageUrl'
        )
      ''';

      // Execute SQL statement
      final body = json.encode({
        'sql': sql,
      });

      final response = await http.put(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Driver added successfully: $responseData');
        // Optionally, you can update the local state or fetch updated driver list here
        await fetchDrivers();
      } else {
        print('Failed to add driver. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding driver: $e');
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    try {
      // Create a unique filename
      String fileName = Uuid().v4();

      // Get a reference to the storage service
      final Reference storageRef = FirebaseStorage.instance.ref();

      // Create a reference to 'driver_licenses/FILENAME.jpg'
      final Reference imageRef =
          storageRef.child('Vehicle_Documents/driver_licenses/$fileName.jpg');

      // Upload the file
      await imageRef.putFile(imageFile);

      // Get the download URL
      String downloadURL = await imageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
