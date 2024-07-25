import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/functions/home_screen_function.dart';
import 'package:insthelper/screens/admin/vehicle_view.dart';
import 'package:intl/intl.dart';

class AlertList extends StatefulWidget {
  const AlertList({super.key});

  @override
  State<AlertList> createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  var filterValue = 1;
  String deviceSearch = '';
  @override
  Widget build(BuildContext context) {
    print("Admin alert list");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(236, 240, 245, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filterValue = 1;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: filterValue != 1
                            ? Colors.white
                            : const Color.fromRGBO(139, 91, 159, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        "Fitness",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                filterValue != 1 ? Colors.black : Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filterValue = 2;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: filterValue != 2
                            ? Colors.white
                            : const Color.fromRGBO(139, 91, 159, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        "Insurance",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                filterValue != 2 ? Colors.black : Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filterValue = 3;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: filterValue != 3
                            ? Colors.white
                            : const Color.fromRGBO(139, 91, 159, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        "Pollution",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                filterValue != 3 ? Colors.black : Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      setState(() {
                        deviceSearch = val;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref('Vehicle-Management')
                      .child('Vehicles')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      Map data = snapshot.data!.snapshot.value as Map;
                      List items = [];

                      data.forEach((key, value) {
                        items.add({"key": key, ...value});
                      });
                      List filteredItems = [];
                      // Filter items based on Fitness Upto date
                      if (filterValue == 1) {
                        filteredItems = items.where((vehicle) {
                          DateTime fitnessUptoDate = DateFormat('yyyy-MM-dd')
                              .parse(vehicle['Fitness Upto']);
                          DateTime now =
                              DateTime.now().add(const Duration(days: 30));
                          bool isFitnessDateBefore =
                              fitnessUptoDate.isBefore(now);

                          // Second condition: Check search criteria
                          bool isSearchMatch = deviceSearch.isEmpty ||
                              vehicle['Registration Number']
                                  .toLowerCase()
                                  .replaceAll('_', ' ')
                                  .contains(deviceSearch.toLowerCase()) ||
                              vehicle['Model']
                                  .toLowerCase()
                                  .contains(deviceSearch.toLowerCase());

                          // Combine both conditions
                          return isFitnessDateBefore && isSearchMatch;
                        }).toList();
                      } else if (filterValue == 2) {
                        filteredItems = items.where((vehicle) {
                          DateTime insuranceUptoDate = DateFormat('yyyy-MM-dd')
                              .parse(vehicle['Insurance Upto']);
                          DateTime now =
                              DateTime.now().add(const Duration(days: 30));
                          bool isInsuranceDateBefore =
                              insuranceUptoDate.isBefore(now);
                          bool isSearchMatch = deviceSearch.isEmpty ||
                              vehicle['Registration Number']
                                  .toLowerCase()
                                  .replaceAll('_', ' ')
                                  .contains(deviceSearch.toLowerCase()) ||
                              vehicle['Model']
                                  .toLowerCase()
                                  .contains(deviceSearch.toLowerCase());
                          return isInsuranceDateBefore && isSearchMatch;
                        }).toList();
                      } else {
                        filteredItems = items.where((vehicle) {
                          DateTime pollutionUptoDate = DateFormat('yyyy-MM-dd')
                              .parse(vehicle['Pollution Upto']);
                          DateTime now =
                              DateTime.now().add(const Duration(days: 30));
                          bool isPollutionDateBefore =
                              pollutionUptoDate.isBefore(now);
                          bool isSearchMatch = deviceSearch.isEmpty ||
                              vehicle['Registration Number']
                                  .toLowerCase()
                                  .replaceAll('_', ' ')
                                  .contains(deviceSearch.toLowerCase()) ||
                              vehicle['Model']
                                  .toLowerCase()
                                  .contains(deviceSearch.toLowerCase());
                          return isPollutionDateBefore && isSearchMatch;
                        }).toList();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          var vehicle = filteredItems[index];
                          return FutureBuilder(
                            future: HomeScreenFunction()
                                .getModelImage(vehicle['Vehicle Type']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VehicleViewScreen(
                                          vehicleRegistrationNo:
                                              vehicle['Registration Number'],
                                          vehicleRegistrationId: vehicle['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  vehicle['Registration Number']
                                                      .toString()
                                                      .toUpperCase()
                                                      .replaceAll('_', ' '),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                                const Spacer(),
                                                const Icon(Icons
                                                    .arrow_circle_right_outlined),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              vehicle['Model'],
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Text(
                                                  filterValue == 1
                                                      ? "Fitness"
                                                      : filterValue == 2
                                                          ? "Insurance"
                                                          : "Pollution",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  filterValue == 1
                                                      ? vehicle['Fitness Upto']
                                                      : filterValue == 2
                                                          ? vehicle[
                                                              'Insurance Upto']
                                                          : vehicle[
                                                              'Pollution Upto'],
                                                ),
                                                // Text(vehicle['Fitness Upto']),
                                              ],
                                            ),
                                            const Spacer(),
                                            const Text(
                                                "We will notify you 30 days before the any validity expiry")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }

                    return const Center(child: Text('No data available.'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
