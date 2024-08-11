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
    List data = [];
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
            data = provider.tripSpecificData;

            if (data.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List vehicleNumber = json.decode(data[0]['vehicle_id']);
              List vehicleDrivers = json.decode(data[0]['driver']);
              List vehicleStartingKm = json.decode(data[0]['starting_km']);
              List tripLocations = json.decode(data[0]['route']);
              String startingTime = data[0]['starting_time'];
              String purpose = data[0]['purpose'];

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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trip Details",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(139, 91, 159, 1)),
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
                                  startingTime,
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
                                  purpose,
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vehicle Details",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(139, 91, 159, 1),
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
                                          vehicleNumber[index]
                                              .replaceAll("_", " "),
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
                                          vehicleDrivers[index],
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
                                          vehicleStartingKm[index],
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Location Details",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(139, 91, 159, 1),
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
                                          tripLocations[index].toString(),
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
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
          onPressed: () {
            if (data.isNotEmpty) {
              List vehicleNumber = json.decode(data[0]['vehicle_id']);
              List vehicleDrivers = json.decode(data[0]['driver']);
              List tripLocations = json.decode(data[0]['route']);
              String startingTime = data[0]['starting_time'];
              String purpose = data[0]['purpose'];

              // Format the details to be shared
              String shareContent = 'Trip Details\n----------------\n'
                  'Date: $startingTime\n'
                  'Purpose: $purpose\n\n'
                  'Vehicle Details\n----------------\n';

              for (int i = 0; i < vehicleNumber.length; i++) {
                shareContent +=
                    'Vehicle ${i + 1}: ${vehicleNumber[i].replaceAll("_", " ")}\n'
                    'Driver: ${vehicleDrivers[i]}\n'
                    'Starting KM: ${data[0]['starting_km'][i]}\n\n';
              }

              shareContent += 'Location Details:\n----------------\n';
              for (int i = 0; i < tripLocations.length; i++) {
                shareContent += 'Location ${i + 1}: ${tripLocations[i]}\n';
              }

              Share.share(
                shareContent,
                subject: 'Trip Details',
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
