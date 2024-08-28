// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class VehicleViewScreen extends StatelessWidget {
  final String vehicleRegistrationId;
  final String vehicleRegistrationNo;
  const VehicleViewScreen(
      {super.key,
      required this.vehicleRegistrationId,
      required this.vehicleRegistrationNo});

  @override
  Widget build(BuildContext context) {
    print("object");
    List data = [];
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final ThemeData theme = Theme.of(context);

    return ChangeNotifierProvider(
        create: (context) => VehicleProvider(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.colorScheme.primaryContainer,
              title: Text(
                vehicleRegistrationNo.replaceAll('_', ' '),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
                  color: theme.scaffoldBackgroundColor,
                  child: ListView(
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
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Owner Details",
                                        style: TextStyle(
                                          fontSize: 22 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Owner Name",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]['ownership'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.apartment,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Registered RTO",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]['rto_name'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.commute,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Vehicle Type",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['vehicle_type'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_transportation,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Model",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['model'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_gas_station_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Fuel Type",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['fuel_type'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.build_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Engine No",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['engine_no'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.construction_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Chassis No",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['chassis_no'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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
                          height: 240,
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
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Registration Date",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['registration_date']))}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Insurance Upto",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Insurance_Upto']))}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Pollution Upto",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Pollution_Upto']))}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Fitness Upto",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(data[0]!['Fitness_Upto']))}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.pin,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Registration No",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['registration_number'].toString().replaceAll('_', ' ')}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.notes_rounded,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Purpose of Use",
                                            style: TextStyle(
                                              fontSize: 19 / textScaleFactor,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        " ${data[0]!['purpose_of_use'].toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 19 / textScaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      top: 10, left: 20, right: 20, bottom: 20),
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
                                              "Gallery",
                                              style: TextStyle(
                                                fontSize: 22 / textScaleFactor,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
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
                                                  jsonDecode(data[0]!['image']);
                                              // Ensure all items are strings
                                              return imageList
                                                  .whereType<String>()
                                                  .map<Widget>((fileName) {
                                                return Container(
                                                  width: 300,
                                                  height: 150,
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Image.network(
                                                    fileName,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                          child: Text(
                                                              'Error loading image'));
                                                    },
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
                );
              },
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: theme.colorScheme.inversePrimary,
              icon: Icons.add,
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
              ],
            )));
  }
}
