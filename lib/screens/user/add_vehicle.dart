// ignore_for_file: avoid_print

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:lottie/lottie.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  int pageNumber = 0;
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

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        // initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Vehicle",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
      ),
      body: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: Form(
              key: _formKey,
              child: (pageNumber == 0)
                  ? ListView(
                      children: [
                        Transform.scale(
                          scale: 3.0, // Adjust the scale factor as needed
                          child: DotLottieLoader.fromAsset(
                            "assets/lottie/add_vehicle.lottie",
                            frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                              if (dotlottie != null) {
                                return Lottie.memory(
                                    dotlottie.animations.values.single);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        FormInputField(
                          textcontroller: registrationNumberController,
                          label: "Registration Number",
                          validator: true,
                          icon: const Icon(Icons.pin),
                        ),
                        FormInputField(
                          textcontroller: makeAndModelController,
                          label: "Model",
                          validator: false,
                          icon: const Icon(Icons.emoji_transportation),
                        ),
                        FormInputField(
                          textcontroller: yearOfManufactureController,
                          label: "Year of Manufacture",
                          validator: false,
                          icon: const Icon(Icons.calendar_month),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_car,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      hint: const Text('Vehicle Type'),
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
                              ],
                            ),
                          ),
                        ),
                        FormInputField(
                          textcontroller: ownerNameController,
                          label: "Owner's Name",
                          validator: false,
                          icon: const Icon(Icons.person),
                        ),
                        FormInputField(
                          textcontroller: assignedDriverController,
                          label: "Assigned Driver",
                          validator: false,
                          icon: const Icon(Icons.person),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    pageNumber = 1;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : ListView(children: [
                      Transform.scale(
                        scale: 3.0, // Adjust the scale factor as needed
                        child: DotLottieLoader.fromAsset(
                          "assets/lottie/add_vehicle.lottie",
                          frameBuilder:
                              (BuildContext ctx, DotLottie? dotlottie) {
                            if (dotlottie != null) {
                              return Lottie.memory(
                                  dotlottie.animations.values.single);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      FormInputField(
                        textcontroller: purposeOfUseController,
                        label: "Purpose of Use",
                        validator: true,
                        icon: const Icon(Icons.notes_rounded),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const Icon(
                                  Icons.calendar_month,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    (selectedDate?.toLocal() != null)
                                        ? "${selectedDate?.toLocal()}"
                                            .split(' ')[0]
                                        : "Insurance Expiry Date",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FormInputField(
                        textcontroller: nextServiceDueDateController,
                        label: "Next Service Due Date",
                        validator: false,
                        icon: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                      FormInputField(
                        textcontroller: inspectionDatesController,
                        label: "Inspection Dates",
                        validator: false,
                        icon: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                      FormInputField(
                        textcontroller: currentMileageController,
                        label: "Current Mileage",
                        validator: false,
                        icon: const Icon(
                          Icons.av_timer,
                        ),
                      ),
                      FormInputField(
                        textcontroller: fuelTypeController,
                        label: "Fuel Type",
                        validator: false,
                        icon: const Icon(
                          Icons.local_gas_station_outlined,
                        ),
                      ),
                      FormInputField(
                        textcontroller: emergencyContactController,
                        label: "Emergency Contact",
                        validator: false,
                        icon: const Icon(
                          Icons.phone,
                        ),
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
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                pageNumber = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back),
                                Text(
                                  "Previous",
                                  style: TextStyle(fontSize: 19),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(fontSize: 19),
                                ),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]))),
    );
  }
}
