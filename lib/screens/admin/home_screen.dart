import 'package:flutter/material.dart';
import 'package:insthelper/components/admin_list_vehicle_widget.dart';
import 'package:insthelper/components/request_permmision.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/admin/vehicle_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            type,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19 / textScaleFactor,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(width: 8 / textScaleFactor),
        Expanded(
          flex: 3,
          child: Text(
            DateFormat('yyyy-MMM-dd').format(nextExpiry),
            style: TextStyle(
              color: Colors.red,
              fontSize: 14 / textScaleFactor,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    RequestPermmision().requestPermission();

    // Get screen size and text scale factor
    final screenSize = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

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

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<HomescreenProvider>()
                              .updateMyVariable(newValue: 3);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/alert');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
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
                                      width: screenSize.width *
                                          0.7, // 70% of screen width
                                      constraints: BoxConstraints(
                                        minHeight: screenSize.height *
                                            0.15, // Minimum height
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    vehicle['registration_number']
                                                        .toString()
                                                        .toUpperCase()
                                                        .replaceAll('_', ' '),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          16 / textScaleFactor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                    Icons
                                                        .arrow_circle_right_outlined,
                                                    size: 24 / textScaleFactor),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 5 / textScaleFactor),
                                            Text(
                                              vehicle['model'],
                                              style: TextStyle(
                                                  fontSize:
                                                      14 / textScaleFactor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                                height: 5 / textScaleFactor),
                                            getNextExpiryLabel(vehicle),
                                            SizedBox(
                                                height: 5 / textScaleFactor),
                                            Text(
                                              "We will notify you 30 days before any validity expiry",
                                              style: TextStyle(
                                                  fontSize:
                                                      12 / textScaleFactor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Vehicle List",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19 / textScaleFactor,
                    ),
                  ),
                ),
                const ListAdminVehicleWidget(
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
