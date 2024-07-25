import 'package:flutter/material.dart';
import 'package:insthelper/components/admin_list_vehicle_widget.dart';
import 'package:insthelper/functions/home_screen_function.dart';
import 'package:insthelper/hive/vehicle_curd_oprtations.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/screens/admin/vehicle_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _combinedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndCombineData();
  }

  Future<void> _fetchAndCombineData() async {
    try {
      // Fetch data from Hive
      List<dynamic> apiVehicles = VehicleCurdOprtations().readVehicle();

      // Combine data (since we're only fetching from Hive)
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
        DateTime aNextExpiry = _getNextExpiryDate(a);
        DateTime bNextExpiry = _getNextExpiryDate(b);
        return aNextExpiry.compareTo(bNextExpiry);
      });

      setState(() {
        _combinedItems = combinedData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching or combining data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  DateTime _getNextExpiryDate(Map vehicle) {
    DateTime pollutionUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
    DateTime fitnessUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
    DateTime insuranceUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
    List<DateTime> dates = [pollutionUpto, fitnessUpto, insuranceUpto];
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  Widget _getNextExpiryLabel(Map vehicle) {
    DateTime pollutionUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
    DateTime fitnessUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
    DateTime insuranceUpto =
        DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
    DateTime nextExpiry = _getNextExpiryDate(vehicle);
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(236, 240, 245, 1),
        child: ListView(
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
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
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
                      Navigator.pushNamed(context, '/alert');
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _combinedItems.isEmpty
                      ? const Center(child: Text('No data available.'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              (_combinedItems.length > 2)
                                  ? 3
                                  : _combinedItems.length,
                              (index) {
                                var vehicle = _combinedItems[index];
                                return FutureBuilder(
                                  future: HomeScreenFunction()
                                      .getModelImage(vehicle['vehicle_type']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 150,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                              builder: (context) =>
                                                  VehicleViewScreen(
                                                vehicleRegistrationId:
                                                    vehicle['id'],
                                                vehicleRegistrationNo: vehicle[
                                                    'registration_number'],
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                            .replaceAll(
                                                                '_', ' '),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  const Spacer(),
                                                  _getNextExpiryLabel(vehicle),
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
                                    }
                                  },
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
            const ListAdminVehicleWidget(
              isHomePage: true,
              isSearch: '',
            )
          ],
        ),
      ),
    );
  }
}
