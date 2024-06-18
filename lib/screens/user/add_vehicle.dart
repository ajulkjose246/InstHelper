import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
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
              FormInputField(
                textcontroller: vehicleTypeController,
                label: "Vehicle Type",
                validator: false,
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
