import 'package:flutter/material.dart';
import 'package:insthelper/components/driver_list_vehicle_widget.dart';
import 'package:insthelper/components/request_permmision.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/driver/vehicle_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchAndCombineData();
  }

  Future<void> _fetchAndCombineData() async {
    try {
      // Fetch data from the API
      await Provider.of<VehicleProvider>(context, listen: false)
          .fetchAllVehicleData();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  DateTime getNextExpiryDate(Map vehicle) {
    DateTime pollutionUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
    DateTime fitnessUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
    DateTime insuranceUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
    List<DateTime> dates = [pollutionUpto, fitnessUpto, insuranceUpto];
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  Widget getNextExpiryLabel(Map vehicle) {
    DateTime pollutionUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
    DateTime fitnessUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
    DateTime insuranceUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
    DateTime nextExpiry = getNextExpiryDate(vehicle);
    String type = '';
    if (nextExpiry == pollutionUpto) {
      type = 'Pollution';
    } else if (nextExpiry == fitnessUpto) {
      type = 'Fitness';
    } else if (nextExpiry == insuranceUpto) {
      type = 'Insurance';
    }
    return Row(
      children: [
        Text(
          type,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 19, color: Colors.red),
        ),
        const Spacer(),
        Text(
          DateFormat('yyyy-MM-dd').format(nextExpiry),
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  // void scheduleNotification(DateTime nextExpiry, String title, String body) {
  //   final now = DateTime.now();
  //   DateTime notificationDate;

  //   // Determine notification frequency
  //   if (now.isAfter(nextExpiry) ||
  //       now.isAfter(nextExpiry.subtract(const Duration(days: 5)))) {
  //     // Schedule daily notifications if current date is after expiry or within 5 days before expiry
  //     notificationDate = now.add(const Duration(days: 1));
  //   } else if (now.isAfter(nextExpiry.subtract(const Duration(days: 30)))) {
  //     // Schedule weekly notifications if current date is within 30 days before expiry
  //     notificationDate = now.add(const Duration(days: 7));
  //   } else {
  //     // Do not schedule notifications if outside the defined ranges
  //     return;
  //   }

  //   // Schedule the notification using flutter_local_notifications
  //   NotificationModel().scheduleExpiryNotification(
  //     title,
  //     body,
  //     notificationDate,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    RequestPermmision().requestPermission();

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(236, 240, 245, 1),
        child: Consumer<VehicleProvider>(
          builder: (context, vehicleProvider, child) {
            List<dynamic> apiVehicles =
                vehicleProvider.vehicles.values.toList();

            // Combine data (since we're only fetching from API in this case)
            List combinedData = apiVehicles;

            // Filter and sort data
            DateTime now = DateTime.now().add(const Duration(days: 30));
            combinedData = combinedData.where((vehicle) {
              DateTime pollutionUpto =
                  DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
              DateTime fitnessUpto =
                  DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
              DateTime insuranceUpto =
                  DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
              return pollutionUpto.isBefore(now) ||
                  fitnessUpto.isBefore(now) ||
                  insuranceUpto.isBefore(now);
            }).toList();

            combinedData.sort((a, b) {
              DateTime aNextExpiry = getNextExpiryDate(a);
              DateTime bNextExpiry = getNextExpiryDate(b);
              return aNextExpiry.compareTo(bNextExpiry);
            });

            // for (var vehicle in combinedData) {
            //   DateTime nextExpiry = getNextExpiryDate(vehicle);
            //   if (nextExpiry.isBefore(now)) {
            //     Widget expiryType = getNextExpiryLabel(vehicle);
            //     scheduleNotification(
            //       nextExpiry,
            //       "Expiry Alert for ${vehicle['registration_number']}",
            //       "The $expiryType of ${vehicle['model']} is expiring on ${DateFormat('yyyy-MM-dd').format(nextExpiry)}. Please renew it.",
            //     );
            //   }
            // }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: TextField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onTap: () {
                              context
                                  .read<HomescreenProvider>()
                                  .updateMyVariable(newValue: 1);
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<HomescreenProvider>()
                              .updateMyVariable(newValue: 3);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image.asset(
                              'assets/img/demo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/driver_alert');
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Icon(Icons.notifications),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: combinedData.isEmpty
                      ? const Center(child: Text('No data available.'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              (combinedData.length > 2)
                                  ? 3
                                  : combinedData.length,
                              (index) {
                                var vehicle = combinedData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VehicleViewScreen(
                                          vehicleRegistrationId: vehicle['id'],
                                          vehicleRegistrationNo:
                                              vehicle['registration_number'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 150,
                                      width: 300,
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
                                                  vehicle['registration_number']
                                                      .toString()
                                                      .toUpperCase()
                                                      .replaceAll('_', ' '),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                                const Spacer(),
                                                const Icon(Icons
                                                    .arrow_circle_right_outlined),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              vehicle['model'],
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const Spacer(),
                                            getNextExpiryLabel(vehicle),
                                            const Spacer(),
                                            const Text(
                                              "We will notify you 30 days before any validity expiry",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Vehicle List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                const ListDriverVehicleWidget(
                  isHomePage: true,
                  isSearch: '',
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
