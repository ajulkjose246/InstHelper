// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/functions/add_vehicle_function.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;

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
  final ownershipController = TextEditingController();
  final purposeOfUseController = TextEditingController();
  final currentMileageController = TextEditingController();
  final emergencyContactController = TextEditingController();

  String? vehicleType;
  String? fuelType;
  String? drivers;

  List<XFile>? uploadedFiles;
  List<String> uploadedImageFileUrls = [];
  List<String> uploadedImageFileNames = [];

  List<String> uploadedFitnessFileUrls = [];
  List<String> uploadedFitnessFileNames = [];

  List<String> uploadedInsuranceFileUrls = [];
  List<String> uploadedInsuranceFileNames = [];

  List<String> uploadedPollutionFileUrls = [];
  List<String> uploadedPollutionFileNames = [];

  List<String> uploadedRcFileUrls = [];
  List<String> uploadedRcFileNames = [];

  Future<void> _pickFiles(String type) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    setState(() {
      if (type == 'image') {
        uploadedFiles = pickedFiles;
        for (var img in uploadedFiles!) {
          uploadedImageFileNames.add(img.name);
        }
      } else if (type == 'fitness') {
        uploadedFiles = pickedFiles;
        for (var img in uploadedFiles!) {
          uploadedFitnessFileNames.add(img.name);
        }
      } else if (type == 'pollution') {
        uploadedFiles = pickedFiles;
        for (var img in uploadedFiles!) {
          uploadedPollutionFileNames.add(img.name);
        }
      } else if (type == 'insurance') {
        uploadedFiles = pickedFiles;
        for (var img in uploadedFiles!) {
          uploadedInsuranceFileNames.add(img.name);
        }
      } else if (type == 'rc') {
        uploadedFiles = pickedFiles;
        for (var img in uploadedFiles!) {
          uploadedRcFileNames.add(img.name);
        }
      }
    });
  }

  Future<void> uploadFiles(String type) async {
    if (uploadedFiles == null || uploadedFiles!.isEmpty) {
      print("No files selected");
      return;
    }

    setState(() {
      isLoading = true;
    });

    for (var file in uploadedFiles!) {
      final fileName = path.basename(file.path);
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('Vehicle_Management')
          .child('files')
          .child(fileName);
      final File localFile = File(file.path);

      try {
        await ref.putFile(localFile);
        final fileUrl = await ref.getDownloadURL();
        print("File uploaded: $fileUrl");

        if (type == 'image') {
          uploadedImageFileUrls.add(fileUrl);
        } else if (type == 'fitness') {
          uploadedFitnessFileUrls.add(fileUrl);
        } else if (type == 'pollution') {
          uploadedPollutionFileUrls.add(fileUrl);
        } else if (type == 'insurance') {
          uploadedInsuranceFileUrls.add(fileUrl);
        } else if (type == 'rc') {
          uploadedRcFileUrls.add(fileUrl);
        }
      } catch (e) {
        print("Failed to upload file: $e");
      }
    }

    setState(() {
      isLoading = false;
    });
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
    print("Admin add vehicle");
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: uploadedImageFileNames.isNotEmpty
                                  ? uploadedImageFileNames.join(', ')
                                  : "No files selected",
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Uploaded Files",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _pickFiles("image");
                                },
                                icon: Icon(Icons.file_upload_outlined),
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (uploadedImageFileNames.isEmpty) {
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                      text: uploadedRcFileNames.isNotEmpty
                                          ? uploadedRcFileNames.join(', ')
                                          : "No files selected",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Uploaded Files",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _pickFiles("rc");
                                        },
                                        icon: Icon(Icons.file_upload_outlined),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                      text:
                                          uploadedInsuranceFileNames.isNotEmpty
                                              ? uploadedInsuranceFileNames
                                                  .join(', ')
                                              : "No files selected",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Uploaded Files",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _pickFiles("insurance");
                                        },
                                        icon: Icon(Icons.file_upload_outlined),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                      text:
                                          uploadedPollutionFileNames.isNotEmpty
                                              ? uploadedPollutionFileNames
                                                  .join(', ')
                                              : "No files selected",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Uploaded Files",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _pickFiles("pollution");
                                        },
                                        icon: Icon(Icons.file_upload_outlined),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                      text: uploadedFitnessFileNames.isNotEmpty
                                          ? uploadedFitnessFileNames.join(', ')
                                          : "No files selected",
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Uploaded Files",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _pickFiles("fitness");
                                        },
                                        icon: Icon(Icons.file_upload_outlined),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
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
                                        await uploadFiles("insurance");
                                        await uploadFiles("pollution");
                                        await uploadFiles("fitness");
                                        await uploadFiles("image");
                                        await uploadFiles("rc");
                                        if (uploadedImageFileUrls.isNotEmpty) {
                                          AddVehicleFunction().addVehicle(
                                              registrationNumberController,
                                              modelController,
                                              registrationDate!,
                                              vehicleType!,
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
                                              uploadedImageFileUrls,
                                              uploadedRcFileUrls,
                                              uploadedPollutionFileUrls,
                                              uploadedInsuranceFileUrls,
                                              uploadedFitnessFileUrls);
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
