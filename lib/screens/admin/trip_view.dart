import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TripViewScreen extends StatelessWidget {
  final int tripId;
  final String tripName;

  const TripViewScreen({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
          title: Text(
            tripName.replaceAll('_', ' '),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<TripProvider>(
          builder: (context, provider, child) {
            provider.fetchSpecificTrip(tripId);
            List data = provider.tripSpecificData;

            if (data.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List vehicleNumber = json.decode(data[0]['vehicle_id']);
              List vehicleDrivers = json.decode(data[0]['driver']);
              List vehicleStartingKm = json.decode(data[0]['starting_km']);
              List tripLocations = json.decode(data[0]['route']);

              return Container(
                color: const Color.fromRGBO(236, 240, 245, 1),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Trip Details",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(139, 91, 159, 1)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return UpdateMessage(
                                    //       dialogHeight: 0.25,
                                    //       type: 1,
                                    //       formattedRegNumber: data[0]
                                    //               ['registration_number']
                                    //           .toString(),
                                    //       vehicleData: data[0],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            236, 240, 245, 1),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Date ",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${data[0]['starting_time']}",
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
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Purpose ",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${data[0]['purpose']}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Vehicle Details",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(139, 91, 159, 1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return UpdateMessage(
                                    //       dialogHeight: 0.25,
                                    //       type: 1,
                                    //       formattedRegNumber: data[0]
                                    //               ['registration_number']
                                    //           .toString(),
                                    //       vehicleData: data[0],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            236, 240, 245, 1),
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
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vehicleNumber.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
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
                                            const SizedBox(width: 10),
                                            Text(
                                              "Vehicle ${index + 1}",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${vehicleNumber[index].replaceAll("_", " ")}",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Driver ",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${vehicleDrivers[index]}",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Starting KM ",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${vehicleStartingKm[index]}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Location Details",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(139, 91, 159, 1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return UpdateMessage(
                                    //       dialogHeight: 0.25,
                                    //       type: 1,
                                    //       formattedRegNumber: data[0]
                                    //               ['registration_number']
                                    //           .toString(),
                                    //       vehicleData: data[0],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            236, 240, 245, 1),
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
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tripLocations.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
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
                                            const SizedBox(width: 10),
                                            Text(
                                              "Location ${index + 1}",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${tripLocations[index]}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
          onPressed: () {
            // Retrieve data from provider to share
            final tripProvider =
                Provider.of<TripProvider>(context, listen: false);
            final data = tripProvider.tripSpecificData;

            if (data.isNotEmpty) {
              Share.share(
                'Vehicle No: ${data[0]['registration_number'].replaceAll('_', ' ')}\n'
                'Owner: ${data[0]['ownership']}\n'
                'Assigned Driver: ${data[0]['assigned_driver']}\n'
                'Type: ${data[0]['vehicle_type']}\n'
                'Model: ${data[0]['model']}\n'
                'Purpose: ${data[0]['purpose_of_use']}\n'
                'Contact: ${data[0]['emergency_contact']}',
                subject: 'Vehicle Details',
              );
            }
          },
          child: const Icon(
            LineIcons.share,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
