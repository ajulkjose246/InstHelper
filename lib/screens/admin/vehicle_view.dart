// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:insthelper/screens/admin/update_popup_message.dart';
import 'package:intl/intl.dart';

class VehicleViewScreen extends StatelessWidget {
  final String vehicleRegistrationId;
  final String vehicleRegistrationNo;
  const VehicleViewScreen(
      {super.key,
      required this.vehicleRegistrationId,
      required this.vehicleRegistrationNo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
          title: Text(
            vehicleRegistrationNo.replaceAll('_', ' '),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<VehicleProvider>(
          builder: (context, provider, child) {
            provider.fetchVehicleData(vehicleRegistrationId);
            if (provider.vehicles[vehicleRegistrationId] == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = provider.vehicles[vehicleRegistrationId];
            return Container(
              color: const Color.fromRGBO(236, 240, 245, 1),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateMessage(
                                        dialogHeight: 0.25,
                                        type: 1,
                                        formattedRegNumber: data[0]
                                                ['registration_number']
                                            .toString(),
                                        vehicleData: data[0],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          236, 240, 245, 1),
                                      borderRadius: BorderRadius.circular(20)),
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
                            const Text(
                              "Owner Details",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(139, 91, 159, 1)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Owner Name",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]['ownership'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.apartment),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Registered RTO",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]['RTO_Name'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      height: 270,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateMessage(
                                        dialogHeight: 0.52,
                                        type: 2,
                                        formattedRegNumber:
                                            data[0]!['registration_number']
                                                .toString(),
                                        vehicleData: data[0],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          236, 240, 245, 1),
                                      borderRadius: BorderRadius.circular(20)),
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
                            const Text(
                              "Vehicle Details",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(139, 91, 159, 1)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.commute),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Vehicle Type",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['vehicle_type'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.emoji_transportation),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Model",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['model'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.local_gas_station_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Fuel Type",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['fuel_type'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.build_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Engine No",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['engine_no'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.construction_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Chassis No",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['chassis_no'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
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
                        color: Colors.white,
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateMessage(
                                        dialogHeight: 0.45,
                                        type: 3,
                                        formattedRegNumber:
                                            data[0]!['registration_number']
                                                .toString(),
                                        vehicleData: data[0],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          236, 240, 245, 1),
                                      borderRadius: BorderRadius.circular(20)),
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
                            const Text(
                              "Important Dates",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(139, 91, 159, 1)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Registration Date",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data[0]!['registration_date']))}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Insurance Upto",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data[0]!['Insurance_Upto']))}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Pollution Upto",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data[0]!['Pollution_Upto']))}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Fitness Upto",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data[0]!['Fitness_Upto']))}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
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
                        color: Colors.white,
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateMessage(
                                        dialogHeight: 0.45,
                                        type: 4,
                                        formattedRegNumber:
                                            data[0]!['registration_number']
                                                .toString(),
                                        vehicleData: data[0],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          236, 240, 245, 1),
                                      borderRadius: BorderRadius.circular(20)),
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
                            const Text(
                              "Other Info",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(139, 91, 159, 1)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.pin),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Registration No",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['registration_number'].toString().replaceAll('_', ' ')}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.notes_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Purpose of Use",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['purpose_of_use'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.phone),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Emergency Contact",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['emergency_contact'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Assigned Driver",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ": ${data[0]!['assigned_driver'].toString()}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // data != null && data!['Uploaded File Names'] != null
                  //     ? Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 10, horizontal: 20),
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           width: double.infinity,
                  //           height: 280,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(
                  //                 top: 10, left: 20, right: 20, bottom: 20),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Align(
                  //                   alignment: Alignment.centerRight,
                  //                   child: GestureDetector(
                  //                     onTap: () {},
                  //                     child: Container(
                  //                       decoration: BoxDecoration(
                  //                           color: const Color.fromRGBO(
                  //                               236, 240, 245, 1),
                  //                           borderRadius:
                  //                               BorderRadius.circular(20)),
                  //                       child: const Padding(
                  //                         padding: EdgeInsets.all(10),
                  //                         child: Icon(
                  //                           Icons.edit,
                  //                           size: 20,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 const Text(
                  //                   "Gallery",
                  //                   style: TextStyle(
                  //                       fontSize: 22,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Color.fromRGBO(139, 91, 159, 1)),
                  //                 ),
                  //                 const SizedBox(height: 10),
                  //                 SingleChildScrollView(
                  //                   scrollDirection: Axis.horizontal,
                  //                   child: Row(
                  //                     children: [
                  //                       ...data!['Uploaded File Names']
                  //                           .map<Widget>((fileName) {
                  //                         return Container(
                  //                           width: 300,
                  //                           height: 150,
                  //                           margin: const EdgeInsets.all(10),
                  //                           decoration: BoxDecoration(
                  //                             color: const Color.fromARGB(
                  //                                 255, 0, 0, 0),
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           child: Image.network(
                  //                             fileName,
                  //                             fit: BoxFit.fill,
                  //                           ),
                  //                         );
                  //                       }).toList(),
                  //                     ],
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
