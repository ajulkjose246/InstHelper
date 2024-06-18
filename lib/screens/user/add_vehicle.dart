// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  List<String> vehicleModels = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final snapshot = await _databaseReference.child("Models").get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List<dynamic>) {
          setState(() {
            // Clear existing items and add new ones
            vehicleModels.clear();
            for (var model in data) {
              if (model is String) {
                vehicleModels.add(model);
              }
            }
          });
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Define controllers for the form fields
  final registrationNumberController = TextEditingController();
  final makeAndModelController = TextEditingController();
  final yearOfManufactureController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final ownerNameController = TextEditingController();
  final assignedDriverController = TextEditingController();
  final purposeOfUseController = TextEditingController();
  final insuranceDetailsController = TextEditingController();
  final insuranceExpiryDateController = TextEditingController();
  final serviceHistoryController = TextEditingController();
  final nextServiceDueDateController = TextEditingController();
  final inspectionDatesController = TextEditingController();
  final currentMileageController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final fuelConsumptionRateController = TextEditingController();
  final parkingLocationController = TextEditingController();
  bool gpsTrackingEnabled = false;
  final emergencyContactController = TextEditingController();

  String? dropdownValue;

  String? uploadedFileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        uploadedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Vehicle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FormInputField(
                textcontroller: registrationNumberController,
                label: "Registration Number",
                validator: true,
              ),
              FormInputField(
                textcontroller: makeAndModelController,
                label: "Model",
                validator: false,
              ),
              FormInputField(
                textcontroller: yearOfManufactureController,
                label: "Year of Manufacture",
                validator: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      hint: Text('Vehicle Type'),
                      items: vehicleModels.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              FormInputField(
                textcontroller: ownerNameController,
                label: "Owner's Name",
                validator: false,
              ),
              FormInputField(
                textcontroller: assignedDriverController,
                label: "Assigned Driver",
                validator: false,
              ),
              FormInputField(
                textcontroller: purposeOfUseController,
                label: "Purpose of Use",
                validator: false,
              ),
              FormInputField(
                textcontroller: insuranceDetailsController,
                label: "Insurance Details",
                validator: false,
              ),
              FormInputField(
                textcontroller: insuranceExpiryDateController,
                label: "Insurance Expiry Date",
                validator: false,
              ),
              FormInputField(
                textcontroller: nextServiceDueDateController,
                label: "Next Service Due Date",
                validator: false,
              ),
              FormInputField(
                textcontroller: inspectionDatesController,
                label: "Inspection Dates",
                validator: false,
              ),
              FormInputField(
                textcontroller: currentMileageController,
                label: "Current Mileage",
                validator: false,
              ),
              FormInputField(
                textcontroller: fuelTypeController,
                label: "Fuel Type",
                validator: false,
              ),
              FormInputField(
                textcontroller: fuelConsumptionRateController,
                label: "Fuel Consumption Rate",
                validator: false,
              ),
              FormInputField(
                textcontroller: emergencyContactController,
                label: "Emergency Contact",
                validator: false,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text("Upload File"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    uploadedFileName ?? "No file selected",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add vehicle data logic here
                  }
                },
                child: Text("Add Vehicle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
