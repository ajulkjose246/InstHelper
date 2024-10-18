// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:AjceTrips/components/vehicle_update_popup_message.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

void _showImagePopup(BuildContext context, String label, String imageUrlsJson) {
  List<String> imageUrls = [];
  try {
    imageUrls = List<String>.from(jsonDecode(imageUrlsJson));
  } catch (e) {
    print("Error parsing image URLs: $e");
    imageUrls = [imageUrlsJson];
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final screenHeight = mediaQuery.size.height;
      final textScaleFactor = mediaQuery.textScaleFactor;

      // Adjust base font size based on screen width
      double baseFontSize = screenWidth < 360 ? 16 : 18;

      // Apply text scale factor and limit maximum size
      double titleFontSize = (baseFontSize / textScaleFactor).clamp(14.0, 22.0);

      return Dialog(
        insetPadding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
        child: Container(
          width: double.maxFinite,
          height: screenHeight * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: titleFontSize),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                  ),
                  items: imageUrls.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(
                                child: Text(
                              'Error loading image',
                              style: TextStyle(fontSize: titleFontSize * 0.8),
                            )),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class VehicleViewScreen extends StatelessWidget {
  final String vehicleRegistrationId;
  final String vehicleRegistrationNo;
  const VehicleViewScreen(
      {super.key,
      required this.vehicleRegistrationId,
      required this.vehicleRegistrationNo});

  @override
  Widget build(BuildContext context) {
    List data = [];
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final ThemeData theme = Theme.of(context);

    return ChangeNotifierProvider(
        create: (context) => VehicleProvider(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primaryContainer,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final textScaleFactor =
                      MediaQuery.of(context).textScaleFactor;
                  final screenWidth = MediaQuery.of(context).size.width;

                  // Adjust base font size based on screen width
                  double baseFontSize = screenWidth < 360 ? 18 : 20;

                  // Apply text scale factor and limit maximum size
                  double fontSize =
                      (baseFontSize / textScaleFactor).clamp(14.0, 24.0);

                  return Text(
                    vehicleRegistrationNo.replaceAll('_', ' '),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                },
              ),
              centerTitle: true,
            ),
            body: Consumer<VehicleProvider>(
              builder: (context, provider, child) {
                provider.fetchVehicleData(vehicleRegistrationNo);
                if (provider.specificVehicles[vehicleRegistrationNo] == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                data = provider.specificVehicles[vehicleRegistrationNo];
                return Container(
                    color: theme.colorScheme.background,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Owner Details",
                                            style: TextStyle(
                                              fontSize: 20 / textScaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return UpdateMessage(
                                                  type: 1,
                                                  formattedRegNumber: data[0][
                                                          'registration_number']
                                                      .toString(),
                                                  vehicleData: data[0],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    _buildInfoRow(
                                      icon: Icons.person,
                                      label: "Owner Name",
                                      value: data[0]['ownership'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.apartment,
                                      label: "Registered RTO",
                                      value: data[0]['rto_name'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Vehicle Details",
                                            style: TextStyle(
                                              fontSize: 22 / textScaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return UpdateMessage(
                                                    type: 2,
                                                    formattedRegNumber: data[
                                                                0]![
                                                            'registration_number']
                                                        .toString(),
                                                    vehicleData: data[0],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: theme
                                                      .scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.commute,
                                      label: "Vehicle Type",
                                      value:
                                          data[0]!['vehicle_type'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.emoji_transportation,
                                      label: "Model",
                                      value: data[0]!['model'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.local_gas_station_outlined,
                                      label: "Fuel Type",
                                      value: data[0]!['fuel_type'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.build_outlined,
                                      label: "Engine No",
                                      value: data[0]!['engine_no'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.construction_outlined,
                                      label: "Chassis No",
                                      value: data[0]!['chassis_no'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20, top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Important Dates",
                                            style: TextStyle(
                                              fontSize: 22 / textScaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return UpdateMessage(
                                                  type: 3,
                                                  formattedRegNumber: data[0]![
                                                          'registration_number']
                                                      .toString(),
                                                  vehicleData: data[0],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildDateRow(
                                      context,
                                      "Registration Date",
                                      data[0]!['registration_date'],
                                      textScaleFactor,
                                      data[0],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildDateRow(
                                      context,
                                      "Insurance Upto",
                                      data[0]!['Insurance_Upto'],
                                      textScaleFactor,
                                      data[0],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildDateRow(
                                      context,
                                      "Pollution Upto",
                                      data[0]!['Pollution_Upto'],
                                      textScaleFactor,
                                      data[0],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildDateRow(
                                      context,
                                      "Fitness Upto",
                                      data[0]!['Fitness_Upto'],
                                      textScaleFactor,
                                      data[0],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: double.infinity,
                              height: 245,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 20, left: 20, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Other Info",
                                            style: TextStyle(
                                              fontSize: 22 / textScaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return UpdateMessage(
                                                  type: 4,
                                                  formattedRegNumber: data[0]![
                                                          'registration_number']
                                                      .toString(),
                                                  vehicleData: data[0],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: theme
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.pin,
                                      label: "Registration No",
                                      value: data[0]!['registration_number']
                                          .toString()
                                          .replaceAll('_', ' '),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(
                                      icon: Icons.notes_rounded,
                                      label: "Purpose of Use",
                                      value:
                                          data[0]!['purpose_of_use'].toString(),
                                      textScaleFactor: textScaleFactor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          data[0]!['image'] != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: double.infinity,
                                    height: 280,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                          bottom: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Gallery",
                                                  style: TextStyle(
                                                    fontSize:
                                                        22 / textScaleFactor,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return UpdateMessage(
                                                        type: 5,
                                                        formattedRegNumber: data[
                                                                    0]![
                                                                'registration_number']
                                                            .toString(),
                                                        vehicleData: data[0],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: theme
                                                          .scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: (() {
                                                try {
                                                  // Parse the JSON string
                                                  List<dynamic> imageList =
                                                      jsonDecode(
                                                          data[0]!['image']);
                                                  // Ensure all items are strings
                                                  return imageList
                                                      .whereType<String>()
                                                      .map<Widget>((fileName) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        _showImagePopup(
                                                            context,
                                                            'Vehicle Image',
                                                            fileName);
                                                      },
                                                      child: Container(
                                                        width: 300,
                                                        height: 150,
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Image.network(
                                                          fileName,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Center(
                                                                child: Text(
                                                                    'Error loading image'));
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                } catch (e) {
                                                  // Handle JSON parsing errors or invalid data
                                                  return [
                                                    Container(
                                                        child: const Center(
                                                            child: Text(
                                                                'Invalid data')))
                                                  ];
                                                }
                                              })(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ));
              },
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: theme.colorScheme.inversePrimary,
              icon: Icons.menu,
              activeIcon: Icons.close,
              foregroundColor: theme.colorScheme.onPrimary,
              overlayColor: theme.scaffoldBackgroundColor,
              overlayOpacity: 0.5,
              children: [
                SpeedDialChild(
                  child:
                      Icon(LineIcons.share, color: theme.colorScheme.onPrimary),
                  backgroundColor: theme.colorScheme.inversePrimary,
                  onTap: () {
                    String shareText = '''
Vehicle Details:
Registration No: ${data[0]!['registration_number']!.replaceAll('_', ' ')}
Owner: ${data[0]!['ownership']}
Registered RTO: ${data[0]!['rto_name']}

Vehicle Info:
Type: ${data[0]!['vehicle_type']}
Model: ${data[0]!['model']}
Fuel Type: ${data[0]!['fuel_type']}
Engine No: ${data[0]!['engine_no']}
Chassis No: ${data[0]!['chassis_no']}

Important Dates:
Registration Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['registration_date']))}
Insurance Upto: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Insurance_Upto']))}
Pollution Upto: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Pollution_Upto']))}
Fitness Upto: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Fitness_Upto']))}

Other Info:
Purpose of Use: ${data[0]!['purpose_of_use']}
''';

                    Share.share(
                      shareText,
                      subject: 'Vehicle Details',
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
                  backgroundColor: theme.colorScheme.inversePrimary,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                              "Are you sure you want to delete this vehicle?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                VehicleProvider().deleteVehicle(
                                    data[0]!['registration_number']);
                                Fluttertoast.showToast(
                                    msg: "Vehicle deleted successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(
                                    context); // Go back to previous screen
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )));
  }

  Widget _buildDateRow(BuildContext context, String label, String date,
      double textScaleFactor, Map<String, dynamic> data) {
    String? imageUrl;
    switch (label) {
      case "Registration Date":
        imageUrl = data['uploaded_files'];
        break;
      case "Insurance Upto":
        imageUrl = data['insurance_documents'];
        break;
      case "Pollution Upto":
        imageUrl = data['pollution_documents'];
        break;
      case "Fitness Upto":
        imageUrl = data['fitness_documents'];
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16 / textScaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  DateFormat('dd-MMM-yyyy').format(DateTime.parse(date)),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16 / textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (imageUrl != null && imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showImagePopup(context, label, imageUrl!);
                    },
                    child: const Icon(Icons.visibility, size: 18),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImagePopup(
      BuildContext context, String label, String imageUrlsJson) {
    List<String> imageUrls = [];
    try {
      imageUrls = List<String>.from(jsonDecode(imageUrlsJson));
    } catch (e) {
      print("Error parsing image URLs: $e");
      // If parsing fails, assume it's a single URL
      imageUrls = [imageUrlsJson];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;
        final textScaleFactor = mediaQuery.textScaleFactor;

        // Adjust base font size based on screen width
        double baseFontSize = screenWidth < 360 ? 16 : 18;

        // Apply text scale factor and limit maximum size
        double titleFontSize =
            (baseFontSize / textScaleFactor).clamp(14.0, 22.0);

        return Dialog(
          insetPadding:
              EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
          child: Container(
            width: double.maxFinite,
            height: screenHeight * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: titleFontSize),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                    ),
                    items: imageUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.contain,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Center(
                                  child: Text(
                                'Error loading image',
                                style: TextStyle(fontSize: titleFontSize * 0.8),
                              )),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildInfoRow({
  required IconData icon,
  required String label,
  required String value,
  required double textScaleFactor,
}) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.grey[600],
        size: 18,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16 / textScaleFactor,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Flexible(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16 / textScaleFactor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}
