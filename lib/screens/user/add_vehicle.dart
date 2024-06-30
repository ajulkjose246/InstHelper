// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/functions/add_vehicle_function.dart';
import 'package:lottie/lottie.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  int pageNumber = 0;

  List<String> vehicleModels = [];
  List<String> vehicleFuels = [];
  List<String> vehicleDrivers = [];

  bool isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    List<String> models = await AddVehicleFunction().fetchModels();
    List<String> fuels = await AddVehicleFunction().fetchFuel();
    List<String> driver = await AddVehicleFunction().fetchDrivers();
    setState(() {
      vehicleModels = models;
      vehicleFuels = fuels;
      vehicleDrivers = driver;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final registrationNumberController = TextEditingController();
  final modelController = TextEditingController();
  final engineNoController = TextEditingController();
  final chassisNoController = TextEditingController();
  final registrationDateController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownershipController = TextEditingController();
  final purposeOfUseController = TextEditingController();
  final pollutionUptoController = TextEditingController();
  final fitnessUptoController = TextEditingController();
  final currentMileageController = TextEditingController();
  final emergencyContactController = TextEditingController();

  String? vehicleType;
  String? fuelType;
  String? drivers;

  PlatformFile? uploadedFile;
  String? uploadedFileName;
  String? uploadedFileUrl;
  UploadTask? uploadTask;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        uploadedFile = result.files.first;
        uploadedFileName = result.files.single.name;
      });
    }
  }

  Future<void> uploadFile() async {
    if (uploadedFile == null) {
      print("uploadedFile is null");
      return;
    }
    setState(() {
      isLoading = true;
    });

    final path = 'files/$uploadedFileName';
    final file = File(uploadedFile!.path!);

    final ref = FirebaseStorage.instance.ref('Vehicle_Management').child(path);
    final uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});

    uploadedFileUrl = await snapshot.ref.getDownloadURL();
    print(uploadedFileUrl);
    await Future.delayed(const Duration(seconds: 2));
  }

  DateTime? insuranceExpiryDate;
  DateTime? registrationDate;
  DateTime? pollutionDate;
  DateTime? fitnessDate;
  Future<void> _selectDate(BuildContext context, String datetype) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != insuranceExpiryDate &&
        datetype == 'insurance') {
      setState(() {
        insuranceExpiryDate = picked;
      });
    }
    if (picked != null &&
        picked != registrationDate &&
        datetype == 'registration') {
      setState(() {
        registrationDate = picked;
      });
    }
    if (picked != null && picked != pollutionDate && datetype == 'pollution') {
      setState(() {
        pollutionDate = picked;
      });
    }
    if (picked != null && picked != fitnessDate && datetype == 'fitness') {
      setState(() {
        fitnessDate = picked;
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
                        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
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
                      regex: RegExp(
                          r'^[a-zA-Z]{2}\s\d{1,2}\s[a-zA-Z]{1,2}\s\d{4}$'),
                      regexlabel: 'KL XX AZ XXXX',
                      numberkeyboard: false,
                    ),
                    FormInputField(
                      textcontroller: modelController,
                      label: "Model",
                      validator: true,
                      icon: const Icon(Icons.emoji_transportation),
                      regex:
                          RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                      regexlabel: 'Hexter',
                      numberkeyboard: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
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
                                  value: vehicleType,
                                  hint: const Text('Vehicle Type'),
                                  items: vehicleModels.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      vehicleType = newValue;
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
                      textcontroller: engineNoController,
                      label: "Engine No",
                      validator: true,
                      icon: const Icon(
                        Icons.build_outlined,
                      ),
                      regex: RegExp(r'^[a-zA-Z0-9-]+$'),
                      regexlabel: '',
                      numberkeyboard: false,
                    ),
                    FormInputField(
                      textcontroller: chassisNoController,
                      label: "Chassis No",
                      validator: true,
                      icon: const Icon(
                        Icons.construction_outlined,
                      ),
                      regex: RegExp(r'^[a-zA-Z0-9-]+$'),
                      regexlabel: '',
                      numberkeyboard: false,
                    ),
                    FormInputField(
                      textcontroller: currentMileageController,
                      label: "Current Mileage",
                      validator: true,
                      icon: const Icon(
                        Icons.av_timer,
                      ),
                      regex: RegExp(r'^\d+(\.\d{1,2})?$'),
                      regexlabel: '',
                      numberkeyboard: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_gas_station_outlined,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: fuelType,
                                  hint: const Text('Fuel Type'),
                                  items: vehicleFuels.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      fuelType = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (uploadedFileName == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please upload a file'),
                                  ),
                                );
                              } else {
                                setState(() {
                                  pageNumber = 1;
                                });
                              }
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
              : (pageNumber == 1)
                  ? ListView(
                      children: [
                        DotLottieLoader.fromAsset(
                          "assets/lottie/add_user.lottie",
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
                        FormInputField(
                          textcontroller: ownerNameController,
                          label: "Owner's Name",
                          validator: true,
                          icon: const Icon(Icons.person),
                          regex: RegExp(
                              r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        FormInputField(
                          textcontroller: ownershipController,
                          label: "Ownership",
                          validator: true,
                          icon: const Icon(Icons.numbers_sharp),
                          regex: RegExp(
                              r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                          regexlabel: '',
                          numberkeyboard: false,
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
                                const Icon(Icons.person),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: drivers,
                                      hint: const Text('Assigned Driver'),
                                      items: vehicleDrivers.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          drivers = newValue;
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
                          textcontroller: purposeOfUseController,
                          label: "Purpose of Use",
                          validator: true,
                          icon: const Icon(Icons.notes_rounded),
                          regex: RegExp(
                              r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        FormInputField(
                          textcontroller: emergencyContactController,
                          label: "Emergency Contact",
                          validator: true,
                          icon: const Icon(
                            Icons.phone,
                          ),
                          regex: RegExp(r"^[6-9]\d{9}$"),
                          regexlabel: '',
                          numberkeyboard: true,
                        ),
                        const SizedBox(height: 20),
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
                                  setState(() {
                                    pageNumber = 2;
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
                      ],
                    )
                  : isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            Transform.scale(
                              scale: 1.0,
                              child: DotLottieLoader.fromAsset(
                                "assets/lottie/add_date.lottie",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () =>
                                    _selectDate(context, 'registration'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
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
                                          (registrationDate != null)
                                              ? "${registrationDate!.toLocal()}"
                                                  .split(' ')[0]
                                              : "Registration Date",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'insurance'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
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
                                          (insuranceExpiryDate != null)
                                              ? "${insuranceExpiryDate!.toLocal()}"
                                                  .split(' ')[0]
                                              : "Insurance Upto",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'pollution'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
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
                                          (pollutionDate != null)
                                              ? "${pollutionDate!.toLocal()}"
                                                  .split(' ')[0]
                                              : "Pollution Upto",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'fitness'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
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
                                          (fitnessDate != null)
                                              ? "${fitnessDate!.toLocal()}"
                                                  .split(' ')[0]
                                              : "Fitness Upto",
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
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      pageNumber = 1;
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
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (registrationDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please select an registration expiry date'),
                                          ),
                                        );
                                      } else if (insuranceExpiryDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please select an insurance expiry date'),
                                          ),
                                        );
                                      } else if (pollutionDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please select an pollution expiry date'),
                                          ),
                                        );
                                      } else if (fitnessDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please select an fitness expiry date'),
                                          ),
                                        );
                                      } else {
                                        await uploadFile();
                                        if (uploadedFileUrl != null) {
                                          AddVehicleFunction().addVehicle(
                                            registrationNumberController,
                                            modelController,
                                            registrationDate!,
                                            vehicleType!,
                                            ownerNameController,
                                            ownershipController,
                                            drivers!,
                                            purposeOfUseController,
                                            insuranceExpiryDate!,
                                            pollutionDate!,
                                            fitnessDate!,
                                            currentMileageController,
                                            fuelType!,
                                            emergencyContactController,
                                            engineNoController,
                                            chassisNoController,
                                            uploadedFileUrl!,
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vehicle added successfully'),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Failed to upload file, please try again.'),
                                            ),
                                          );
                                        }
                                      }
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
                                        "Submit",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Icon(Icons.check),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
        ),
      ),
    );
  }
}
