import 'package:flutter/material.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

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

  // Add a new state variable for new images
  List<File> newImages = [];

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

  Future<void> _selectNewImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        newImages.addAll(images.map((xFile) => File(xFile.path)));
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    // Adjust base font size based on screen width
    double baseFontSize = screenWidth < 360 ? 16 : 18;

    // Apply text scale factor and limit maximum size
    double titleFontSize = (baseFontSize / textScaleFactor).clamp(14.0, 22.0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: Container(
            width: screenWidth * 0.9,
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: _buildDialogContent(
                context, titleFontSize, screenWidth, screenHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, double titleFontSize,
      double screenWidth, double screenHeight) {
    switch (widget.type) {
      case 1:
        return _buildOwnerDetailsContent(
            titleFontSize, screenWidth, screenHeight);
      case 2:
        return _buildVehicleDetailsContent(
            titleFontSize, screenWidth, screenHeight);
      case 3:
        return _buildImportantDatesContent(
            titleFontSize, screenWidth, screenHeight);
      case 4:
        return _buildOtherInfoContent(titleFontSize, screenWidth, screenHeight);
      case 5:
        return _buildNewImagesContent(titleFontSize, screenWidth, screenHeight);
      default:
        return Container();
    }
  }

  Widget _buildOwnerDetailsContent(
      double titleFontSize, double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update Owner Details",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: ownershipController,
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    prefixIcon: Icon(Icons.person, size: titleFontSize),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.04,
                    ),
                    labelStyle: TextStyle(fontSize: titleFontSize * 0.8),
                  ),
                  style: TextStyle(fontSize: titleFontSize * 0.8),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
        _buildActionButtons(context, titleFontSize),
      ],
    );
  }

  Widget _buildVehicleDetailsContent(
      double titleFontSize, double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update Vehicle Details",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
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
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
                FormInputField(
                  textcontroller: modelController,
                  label: "Model",
                  validator: true,
                  icon: const Icon(Icons.emoji_transportation),
                  regex: RegExp(''),
                  regexlabel: 'KL XX AZ XXXX',
                  numberkeyboard: false,
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
                FormInputField(
                  textcontroller: fuelTypeController,
                  label: "Fuel Type",
                  validator: true,
                  icon: const Icon(Icons.local_gas_station_outlined),
                  regex: RegExp(''),
                  regexlabel: 'KL XX AZ XXXX',
                  numberkeyboard: false,
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
                FormInputField(
                  textcontroller: engineNoController,
                  label: "Engine No",
                  validator: true,
                  icon: const Icon(Icons.build_outlined),
                  regex: RegExp(''),
                  regexlabel: 'KL XX AZ XXXX',
                  numberkeyboard: false,
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
                FormInputField(
                  textcontroller: chassisNoController,
                  label: "Chassis No",
                  validator: true,
                  icon: const Icon(Icons.construction_outlined),
                  regex: RegExp(''),
                  regexlabel: 'KL XX AZ XXXX',
                  numberkeyboard: false,
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
              ],
            ),
          ),
        ),
        _buildActionButtons(context, titleFontSize),
      ],
    );
  }

  Widget _buildImportantDatesContent(
      double titleFontSize, double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Important Dates",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDateFieldWithUpload(
                  context,
                  'registration',
                  'Registration Date',
                  registrationDate,
                  titleFontSize,
                  screenWidth,
                  screenHeight,
                ),
                _buildDateFieldWithUpload(
                  context,
                  'insurance',
                  'Insurance Upto',
                  insuranceExpiryDate,
                  titleFontSize,
                  screenWidth,
                  screenHeight,
                ),
                _buildDateFieldWithUpload(
                  context,
                  'pollution',
                  'Pollution Upto',
                  pollutionDate,
                  titleFontSize,
                  screenWidth,
                  screenHeight,
                ),
                _buildDateFieldWithUpload(
                  context,
                  'fitness',
                  'Fitness Upto',
                  fitnessDate,
                  titleFontSize,
                  screenWidth,
                  screenHeight,
                ),
              ],
            ),
          ),
        ),
        _buildActionButtons(context, titleFontSize),
      ],
    );
  }

  Widget _buildOtherInfoContent(
      double titleFontSize, double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update Other Info",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormInputField(
                  textcontroller: purposeOfUseController,
                  label: "Purpose of Use",
                  validator: true,
                  icon: const Icon(Icons.notes_rounded),
                  regex: RegExp(''),
                  regexlabel: 'KL XX AZ XXXX',
                  numberkeyboard: false,
                  fontSize: titleFontSize * 0.8, // Add this line
                ),
              ],
            ),
          ),
        ),
        _buildActionButtons(context, titleFontSize),
      ],
    );
  }

  Widget _buildNewImagesContent(
      double titleFontSize, double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add New Images",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildNewImageUploadField(
                    titleFontSize, screenWidth, screenHeight),
                if (newImages.isNotEmpty)
                  _buildNewImagesPreview(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
        _buildActionButtons(context, titleFontSize),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, double titleFontSize) {
    return Row(
      children: [
        TextButton(
          child: Text('Close', style: TextStyle(fontSize: titleFontSize * 0.7)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        TextButton(
          child:
              Text('Update', style: TextStyle(fontSize: titleFontSize * 0.7)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                },
              );

              // Perform update action
              await _updateVehicleData();

              // Hide loading indicator
              Navigator.of(context).pop();

              // Close the update dialog
              Navigator.of(context).pop();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vehicle updated successfully')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDateFieldWithUpload(
    BuildContext context,
    String dateType,
    String label,
    DateTime? date,
    double titleFontSize,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: titleFontSize * 0.8,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _buildDateField(context, dateType, label, date, titleFontSize,
            screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.015),
        Text(
          "Upload $label Document",
          style: TextStyle(
            fontSize: titleFontSize * 0.7,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        _buildImageUploadField(
            dateType, titleFontSize, screenWidth, screenHeight),
        if (selectedImages[dateType]!.isNotEmpty)
          _buildSelectedImagesPreview(dateType, screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String dateType,
    String label,
    DateTime? date,
    double titleFontSize,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: GestureDetector(
        onTap: () => _selectDate(context, dateType),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.calendar_month, size: titleFontSize * 0.8),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Text(
                  date != null ? formatDate(date) : label,
                  style: TextStyle(
                    fontSize: titleFontSize * 0.8,
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

  Widget _buildImageUploadField(
    String dateType,
    double titleFontSize,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: () => _selectImages(dateType),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(Icons.upload_file, size: titleFontSize * 0.8),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                selectedImages[dateType]!.isNotEmpty
                    ? '${selectedImages[dateType]!.length} image(s) selected'
                    : 'Upload Documents',
                style: TextStyle(
                  fontSize: titleFontSize * 0.8,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesPreview(
    String dateType,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight * 0.1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages[dateType]!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: Stack(
              children: [
                Image.file(
                  selectedImages[dateType]![index],
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.1,
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
                      child: Icon(Icons.close, size: 12, color: Colors.white),
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

  Widget _buildNewImageUploadField(
    double titleFontSize,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: _selectNewImages,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(Icons.add_photo_alternate, size: titleFontSize * 0.8),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                newImages.isNotEmpty
                    ? '${newImages.length} image(s) selected'
                    : 'Select New Images',
                style: TextStyle(
                  fontSize: titleFontSize * 0.8,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewImagesPreview(
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight * 0.2,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: screenWidth * 0.02,
          mainAxisSpacing: screenHeight * 0.02,
        ),
        itemCount: newImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Image.file(
                newImages[index],
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      newImages.removeAt(index);
                    });
                  },
                  child: Container(
                    color: Colors.red,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateVehicleData() async {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);

    switch (widget.type) {
      case 1:
        await vehicleProvider.updateVehicleData(
          1,
          widget.formattedRegNumber,
          ownershipController.text,
        );
        break;
      case 2:
        await vehicleProvider.updateVehicleData(
          2,
          widget.formattedRegNumber,
          vehicleTypeController.text,
          modelController.text,
          fuelTypeController.text,
          engineNoController.text,
          chassisNoController.text,
        );
        break;
      case 3:
        await vehicleProvider.updateVehicleData(
          3,
          widget.formattedRegNumber,
          registrationDate?.toIso8601String(),
          insuranceExpiryDate?.toIso8601String(),
          pollutionDate?.toIso8601String(),
          fitnessDate?.toIso8601String(),
          null,
          selectedImages,
        );
        break;
      case 4:
        await vehicleProvider.updateVehicleData(
          4,
          widget.formattedRegNumber,
          purposeOfUseController.text,
        );
        break;
      case 5:
        await vehicleProvider.updateVehicleData(
          5,
          widget.formattedRegNumber,
          null,
          null,
          null,
          null,
          null,
          null,
          newImages,
        );
        break;
    }
  }
}
