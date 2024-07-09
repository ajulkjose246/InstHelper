import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/functions/update_vehicle_function.dart';

class UpdateMessage extends StatefulWidget {
  const UpdateMessage({
    super.key,
    required this.dialogHeight,
    required this.type,
    required this.formattedRegNumber,
    required this.vehicleData,
  });

  final double dialogHeight;
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
  final emergencyContactController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final fuelTypeController = TextEditingController();

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
  void initState() {
    super.initState();
    ownershipController.text = widget.vehicleData!['Owner Name'];
    vehicleTypeController.text = widget.vehicleData!['Vehicle Type'];
    modelController.text = widget.vehicleData!['Model'];
    fuelTypeController.text = widget.vehicleData!['Fuel Type'];
    engineNoController.text = widget.vehicleData!['Engine No'];
    chassisNoController.text = widget.vehicleData!['Chassis No'];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * widget.dialogHeight,
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
                              UpdateVehicleFunction().updateVehicleOwnerDetails(
                                  ownershipController,
                                  widget.formattedRegNumber);
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
                                  icon: const Icon(Icons.emoji_transportation),
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
                                  icon: const Icon(Icons.construction_outlined),
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
                                  UpdateVehicleFunction().updateVehicleDetails(
                                      vehicleTypeController,
                                      modelController,
                                      fuelTypeController,
                                      engineNoController,
                                      chassisNoController,
                                      widget.formattedRegNumber);
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: GestureDetector(
                                        onTap: () => _selectDate(
                                            context, 'registration'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _selectDate(context, 'insurance'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _selectDate(context, 'pollution'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _selectDate(context, 'fitness'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                      Navigator.of(context).pop();
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
                                              registrationNumberController,
                                          label: "Purpose of Use",
                                          validator: true,
                                          icon: const Icon(Icons.notes_rounded),
                                          regex: RegExp(
                                              r'^[a-zA-Z]{2}\s\d{1,2}\s[a-zA-Z]{1,2}\s\d{4}$'),
                                          regexlabel: 'KL XX AZ XXXX',
                                          numberkeyboard: false,
                                        ),
                                        FormInputField(
                                          textcontroller:
                                              registrationNumberController,
                                          label: "Emergency Contact",
                                          validator: true,
                                          icon: const Icon(Icons.phone),
                                          regex: RegExp(
                                              r'^[a-zA-Z]{2}\s\d{1,2}\s[a-zA-Z]{1,2}\s\d{4}$'),
                                          regexlabel: 'KL XX AZ XXXX',
                                          numberkeyboard: false,
                                        ),
                                        FormInputField(
                                          textcontroller:
                                              registrationNumberController,
                                          label: "Assigned Driver",
                                          validator: true,
                                          icon: const Icon(Icons.person),
                                          regex: RegExp(
                                              r'^[a-zA-Z]{2}\s\d{1,2}\s[a-zA-Z]{1,2}\s\d{4}$'),
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
                                          Navigator.of(context).pop();
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
    );
  }
}
