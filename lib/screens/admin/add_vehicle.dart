// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  int pageNumber = 0;

  List vehicleModels = [];
  List<String> vehicleFuels = [];
  List<String> vehicleDrivers = [];

  bool isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();

  final registrationNumberController = TextEditingController();
  final modelController = TextEditingController();
  final engineNoController = TextEditingController();
  final chassisNoController = TextEditingController();
  final ownershipController = TextEditingController();
  final purposeOfUseController = TextEditingController();
  final currentKMController = TextEditingController();

  String? vehicleType;
  String? fuelType;

  Map<String, List<XFile>> uploadedFiles = {
    'image': [],
    'fitness': [],
    'pollution': [],
    'insurance': [],
    'rc': [],
  };

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
      uploadedFiles[type] = pickedFiles;
      switch (type) {
        case 'image':
          uploadedImageFileNames =
              pickedFiles.map((file) => file.name).toList();
          break;
        case 'fitness':
          uploadedFitnessFileNames =
              pickedFiles.map((file) => file.name).toList();
          break;
        case 'pollution':
          uploadedPollutionFileNames =
              pickedFiles.map((file) => file.name).toList();
          break;
        case 'insurance':
          uploadedInsuranceFileNames =
              pickedFiles.map((file) => file.name).toList();
          break;
        case 'rc':
          uploadedRcFileNames = pickedFiles.map((file) => file.name).toList();
          break;
      }
    });
  }

  Future<void> uploadFiles(String type) async {
    final files = uploadedFiles[type];
    if (files == null || files.isEmpty) {
      print("No files selected for $type");
      return;
    }

    setState(() {
      isLoading = true;
    });

    for (var file in files) {
      final fileName = path.basename(file.path);
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('Vehicle_Documents')
          .child(type)
          .child(fileName);
      final File localFile = File(file.path);

      try {
        await ref.putFile(localFile);
        final fileUrl = await ref.getDownloadURL();
        print("File uploaded: $fileUrl");

        switch (type) {
          case 'image':
            uploadedImageFileUrls.add(fileUrl);
            break;
          case 'fitness':
            uploadedFitnessFileUrls.add(fileUrl);
            break;
          case 'pollution':
            uploadedPollutionFileUrls.add(fileUrl);
            break;
          case 'insurance':
            uploadedInsuranceFileUrls.add(fileUrl);
            break;
          case 'rc':
            uploadedRcFileUrls.add(fileUrl);
            break;
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
        firstDate: DateTime(1900, 8),
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
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    // Adjust base font size based on screen width
    double baseFontSize = screenWidth < 360 ? 16 : 18;

    // Apply text scale factor and limit maximum size
    double titleFontSize = (baseFontSize / textScaleFactor).clamp(14.0, 22.0);
    double bodyFontSize =
        (baseFontSize * 0.9 * textScaleFactor).clamp(12.0, 20.0);

    // Adjust padding based on screen size
    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Vehicle",
          style: TextStyle(color: Colors.white, fontSize: titleFontSize),
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Form(
          key: _formKey,
          child: (pageNumber == 0)
              ? ListView(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.3, // Adjust as needed
                      child: DotLottieLoader.fromAsset(
                        "assets/lottie/add_vehicle.lottie",
                        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single,
                                fit: BoxFit.contain);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FormInputField(
                      textcontroller: registrationNumberController,
                      label: "Registration Number",
                      validator: true,
                      icon: Icon(Icons.pin, color: theme.colorScheme.primary),
                      regex: RegExp(
                          r'^[a-zA-Z]{2}\s\d{1,2}\s([a-zA-Z]{1,2}\s)?\d{4}$'),
                      regexlabel: 'KL XX AZ XXXX or KL XX XXXX',
                      numberkeyboard: false,
                      fontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FormInputField(
                      textcontroller: modelController,
                      label: "Model",
                      validator: true,
                      icon: Icon(Icons.emoji_transportation,
                          color: theme.colorScheme.primary),
                      regex: RegExp(r"^[a-zA-Z0-9]+([\s\-',.][a-zA-Z0-9]+)*$"),
                      regexlabel: 'e.g. Ashok Leyland, Swift Dzire',
                      numberkeyboard: false,
                      fontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.outline, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.directions_car,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Consumer<VehicleProvider>(
                                builder: (context, vehicleProvider, child) {
                                  final vehicleModels = vehicleProvider
                                          .vehicleModels['vehicleTypes'] ??
                                      [];
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: vehicleType,
                                      hint: const Text('Vehicle Type'),
                                      items: vehicleModels
                                          .map<DropdownMenuItem<String>>(
                                              (vehicle) {
                                        return DropdownMenuItem<String>(
                                          value: vehicle['type'],
                                          child: Text(vehicle['type']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          vehicleType = newValue;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FormInputField(
                      textcontroller: engineNoController,
                      label: "Engine No",
                      validator: false,
                      icon: Icon(
                        Icons.build_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      regex: RegExp(r'^[a-zA-Z0-9-]+$'),
                      regexlabel: '',
                      numberkeyboard: false,
                      fontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FormInputField(
                      textcontroller: chassisNoController,
                      label: "Chassis No",
                      validator: false,
                      icon: Icon(
                        Icons.construction_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      regex: RegExp(r'^[a-zA-Z0-9-]+$'),
                      regexlabel: '',
                      numberkeyboard: false,
                      fontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FormInputField(
                      textcontroller: currentKMController,
                      label: "Current KM",
                      validator: true,
                      icon: Icon(
                        Icons.av_timer,
                        color: theme.colorScheme.primary,
                      ),
                      regex: RegExp(r'^\d+(\.\d{1,2})?$'),
                      regexlabel: '',
                      numberkeyboard: true,
                      fontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.outline, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_gas_station_outlined,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Consumer<VehicleProvider>(
                                builder: (context, vehicleProvider, child) {
                                  final vehicleFuel = vehicleProvider
                                          .vehicleFuel['vehicleFuel'] ??
                                      [];
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: fuelType,
                                      hint: const Text('Fuel Type'),
                                      items: vehicleFuel
                                          .map<DropdownMenuItem<String>>(
                                              (vehicle) {
                                        return DropdownMenuItem<String>(
                                          value: vehicle['type'],
                                          child: Text(vehicle['type']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          fuelType = newValue;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
                                icon: Icon(Icons.file_upload_outlined,
                                    color: theme.colorScheme.primary),
                              ),
                            ),
                            style: TextStyle(fontSize: titleFontSize),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(fontSize: titleFontSize),
                              ),
                              Icon(Icons.arrow_forward,
                                  size: titleFontSize * 1.2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                )
              : (pageNumber == 1)
                  ? ListView(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.3, // Adjust as needed
                          child: DotLottieLoader.fromAsset(
                            "assets/lottie/add_user.lottie",
                            frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                              if (dotlottie != null) {
                                return Lottie.memory(
                                  dotlottie.animations.values.single,
                                  fit: BoxFit.contain,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        FormInputField(
                          textcontroller: ownershipController,
                          label: "Ownership",
                          validator: true,
                          icon: Icon(Icons.numbers_sharp,
                              color: theme.colorScheme.primary),
                          regex: RegExp(
                              r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                          regexlabel: '',
                          numberkeyboard: false,
                          fontSize: titleFontSize,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        FormInputField(
                          textcontroller: purposeOfUseController,
                          label: "Purpose of Use",
                          validator: true,
                          icon: Icon(Icons.notes_rounded,
                              color: theme.colorScheme.primary),
                          regex: RegExp(
                              r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                          regexlabel: '',
                          numberkeyboard: false,
                          fontSize: titleFontSize,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    pageNumber = 0;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back, size: titleFontSize),
                                    SizedBox(width: 8),
                                    Text(
                                      "Previous",
                                      style: TextStyle(fontSize: titleFontSize),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      pageNumber = 2;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Next",
                                      style: TextStyle(fontSize: titleFontSize),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward,
                                        size: titleFontSize),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    )
                  : isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: theme.colorScheme.primary))
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
                            SizedBox(height: screenHeight * 0.02),
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
                                        color: theme.colorScheme.outline,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_month,
                                        color: theme.colorScheme.primary,
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
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color:
                                                theme.colorScheme.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                                        icon: Icon(Icons.file_upload_outlined,
                                            color: theme.colorScheme.primary),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: titleFontSize),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'insurance'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorScheme.outline,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_month,
                                        color: theme.colorScheme.primary,
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
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color:
                                                theme.colorScheme.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                                        icon: Icon(Icons.file_upload_outlined,
                                            color: theme.colorScheme.primary),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: titleFontSize),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'pollution'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorScheme.outline,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_month,
                                        color: theme.colorScheme.primary,
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
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color:
                                                theme.colorScheme.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                                        icon: Icon(Icons.file_upload_outlined,
                                            color: theme.colorScheme.primary),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: titleFontSize),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'fitness'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorScheme.outline,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_month,
                                        color: theme.colorScheme.primary,
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
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color:
                                                theme.colorScheme.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                                        icon: const Icon(
                                            Icons.file_upload_outlined),
                                      ),
                                    ),
                                    style: TextStyle(fontSize: titleFontSize),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      pageNumber = 1;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.arrow_back,
                                          size: titleFontSize * 1.2),
                                      Text(
                                        "Previous",
                                        style: TextStyle(
                                            fontSize: titleFontSize * 0.8),
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
                                        if (uploadedFiles != null &&
                                            uploadedFiles!.isNotEmpty) {
                                          await uploadFiles("insurance");
                                          await uploadFiles("pollution");
                                          await uploadFiles("fitness");
                                          await uploadFiles("image");
                                          await uploadFiles("rc");
                                        }
                                        VehicleProvider().addVehicle(
                                            registrationNumberController,
                                            modelController,
                                            registrationDate!,
                                            vehicleType!,
                                            ownershipController,
                                            purposeOfUseController,
                                            insuranceExpiryDate!,
                                            pollutionDate!,
                                            fitnessDate!,
                                            currentKMController,
                                            fuelType!,
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
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.015,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontSize: titleFontSize * 0.8),
                                      ),
                                      Icon(Icons.check,
                                          size: titleFontSize * 1.2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
        ),
      ),
    );
  }
}
