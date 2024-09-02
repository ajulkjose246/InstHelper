import 'package:flutter/material.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateMessage extends StatefulWidget {
  const UpdateMessage({
    super.key,
    required this.type,
    required this.formattedRegNumber,
    required this.vehicleData,
  });

  final int type;
  final String formattedRegNumber;
  final Map<String, dynamic>? vehicleData;

  @override
  State<UpdateMessage> createState() => _UpdateMessageState();
}

class _UpdateMessageState extends State<UpdateMessage> {
  final _formKey = GlobalKey<FormState>();

  final registrationNumberController = TextEditingController();
  final modelController = TextEditingController();
  final engineNoController = TextEditingController();
  final chassisNoController = TextEditingController();
  final ownershipController = TextEditingController();
  final purposeOfUseController = TextEditingController();
  final currentMileageController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final fuelTypeController = TextEditingController();

  DateTime? insuranceExpiryDate;
  DateTime? registrationDate;
  DateTime? pollutionDate;
  DateTime? fitnessDate;
  Map<String, List<File>> selectedImages = {
    'registration': [],
    'insurance': [],
    'pollution': [],
    'fitness': [],
  };

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

  Future<void> _selectImages(String dateType) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        selectedImages[dateType] =
            images.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ownershipController.text = widget.vehicleData!['ownership'];
    vehicleTypeController.text = widget.vehicleData!['vehicle_type'];
    modelController.text = widget.vehicleData!['model'];
    fuelTypeController.text = widget.vehicleData!['fuel_type'];
    engineNoController.text = widget.vehicleData!['engine_no'];
    chassisNoController.text = widget.vehicleData!['chassis_no'];
    registrationDate = DateTime.parse(widget.vehicleData!['registration_date']);
    insuranceExpiryDate = DateTime.parse(widget.vehicleData!['Insurance_Upto']);
    pollutionDate = DateTime.parse(widget.vehicleData!['Pollution_Upto']);
    fitnessDate = DateTime.parse(widget.vehicleData!['Fitness_Upto']);
    purposeOfUseController.text = widget.vehicleData!['purpose_of_use'];
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            child: (widget.type == 1)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Update Owner Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FormInputField(
                                textcontroller: ownershipController,
                                label: 'Owner Name',
                                validator: true,
                                icon: const Icon(Icons.person),
                                regex: RegExp(
                                    r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                                regexlabel: '',
                                numberkeyboard: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Spacer(),
                          TextButton(
                            child: const Text('Update'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                VehicleProvider().updateVehicleData(
                                  widget.type,
                                  widget.vehicleData!['registration_number'],
                                  ownershipController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  )
                : (widget.type == 2)
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Update Vehicle Details",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FormInputField(
                                    textcontroller: vehicleTypeController,
                                    label: "Vehicle Type",
                                    validator: true,
                                    icon: const Icon(Icons.commute),
                                    regex: RegExp(''),
                                    regexlabel: 'KL XX AZ XXXX',
                                    numberkeyboard: false,
                                  ),
                                  FormInputField(
                                    textcontroller: modelController,
                                    label: "Model",
                                    validator: true,
                                    icon:
                                        const Icon(Icons.emoji_transportation),
                                    regex: RegExp(''),
                                    regexlabel: 'KL XX AZ XXXX',
                                    numberkeyboard: false,
                                  ),
                                  FormInputField(
                                    textcontroller: fuelTypeController,
                                    label: "Fuel Type",
                                    validator: true,
                                    icon: const Icon(
                                        Icons.local_gas_station_outlined),
                                    regex: RegExp(''),
                                    regexlabel: 'KL XX AZ XXXX',
                                    numberkeyboard: false,
                                  ),
                                  FormInputField(
                                    textcontroller: engineNoController,
                                    label: "Engine No",
                                    validator: true,
                                    icon: const Icon(Icons.build_outlined),
                                    regex: RegExp(''),
                                    regexlabel: 'KL XX AZ XXXX',
                                    numberkeyboard: false,
                                  ),
                                  FormInputField(
                                    textcontroller: chassisNoController,
                                    label: "Chassis No",
                                    validator: true,
                                    icon:
                                        const Icon(Icons.construction_outlined),
                                    regex: RegExp(''),
                                    regexlabel: 'KL XX AZ XXXX',
                                    numberkeyboard: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              const Spacer(),
                              TextButton(
                                child: const Text('Update'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    VehicleProvider().updateVehicleData(
                                      widget.type,
                                      widget
                                          .vehicleData!['registration_number'],
                                      vehicleTypeController.text,
                                      modelController.text,
                                      fuelTypeController.text,
                                      engineNoController.text,
                                      chassisNoController.text,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    : (widget.type == 3)
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Important Dates",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      _buildDateFieldWithUpload(
                                        context,
                                        'registration',
                                        'Registration Date',
                                        registrationDate,
                                      ),
                                      _buildDateFieldWithUpload(
                                        context,
                                        'insurance',
                                        'Insurance Upto',
                                        insuranceExpiryDate,
                                      ),
                                      _buildDateFieldWithUpload(
                                        context,
                                        'pollution',
                                        'Pollution Upto',
                                        pollutionDate,
                                      ),
                                      _buildDateFieldWithUpload(
                                        context,
                                        'fitness',
                                        'Fitness Upto',
                                        fitnessDate,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    child: const Text('Update'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (registrationDate
                                                ?.toIso8601String()
                                                .split('T')[0] ==
                                            widget.vehicleData![
                                                'registration_date']) {
                                          registrationDate = null;
                                        }
                                        if (insuranceExpiryDate
                                                ?.toIso8601String()
                                                .split('T')[0] ==
                                            widget.vehicleData![
                                                'Insurance_Upto']) {
                                          insuranceExpiryDate = null;
                                        }
                                        if (pollutionDate
                                                ?.toIso8601String()
                                                .split('T')[0] ==
                                            widget.vehicleData![
                                                'Pollution_Upto']) {
                                          pollutionDate = null;
                                        }
                                        if (fitnessDate
                                                ?.toIso8601String()
                                                .split('T')[0] ==
                                            widget
                                                .vehicleData!['Fitness_Upto']) {
                                          fitnessDate = null;
                                        }
                                        VehicleProvider().updateVehicleData(
                                          widget.type,
                                          widget.vehicleData![
                                              'registration_number'],
                                          registrationDate
                                              ?.toIso8601String()
                                              .split('T')[0],
                                          insuranceExpiryDate
                                              ?.toIso8601String()
                                              .split('T')[0],
                                          pollutionDate
                                              ?.toIso8601String()
                                              .split('T')[0],
                                          fitnessDate
                                              ?.toIso8601String()
                                              .split('T')[0],
                                          null,
                                          selectedImages,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        : (widget.type == 4)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Update Other Info",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          FormInputField(
                                            textcontroller:
                                                purposeOfUseController,
                                            label: "Purpose of Use",
                                            validator: true,
                                            icon:
                                                const Icon(Icons.notes_rounded),
                                            regex: RegExp(''),
                                            regexlabel: 'KL XX AZ XXXX',
                                            numberkeyboard: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        child: const Text('Update'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            VehicleProvider().updateVehicleData(
                                              widget.type,
                                              widget.vehicleData![
                                                  'registration_number'],
                                              purposeOfUseController.text,
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDateFieldWithUpload(
    BuildContext context,
    String dateType,
    String label,
    DateTime? date,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildDateField(context, dateType, label, date),
        const SizedBox(height: 10),
        Text(
          "Upload $label Document",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        _buildImageUploadField(dateType),
        if (selectedImages[dateType]!.isNotEmpty)
          _buildSelectedImagesPreview(dateType),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateField(
      BuildContext context, String dateType, String label, DateTime? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => _selectDate(context, dateType),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Icon(Icons.calendar_month),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  date != null ? formatDate(date) : label,
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
    );
  }

  Widget _buildImageUploadField(String dateType) {
    return GestureDetector(
      onTap: () => _selectImages(dateType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Icon(Icons.upload_file),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedImages[dateType]!.isNotEmpty
                    ? '${selectedImages[dateType]!.length} image(s) selected'
                    : 'Upload Documents',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesPreview(String dateType) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages[dateType]!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                Image.file(
                  selectedImages[dateType]![index],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImages[dateType]!.removeAt(index);
                      });
                    },
                    child: Container(
                      color: Colors.red,
                      child: Icon(Icons.close, size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
