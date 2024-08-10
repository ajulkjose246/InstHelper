import 'package:flutter/material.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/admin/vehicle_view.dart';
import 'package:provider/provider.dart';
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
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    if (vehicleProvider.vehicles.isEmpty) {
      vehicleProvider.fetchAllVehicleData();
    }

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
                  // Filter buttons
                  _buildFilterButton(1, "Fitness"),
                  const SizedBox(width: 10),
                  _buildFilterButton(2, "Insurance"),
                  const SizedBox(width: 10),
                  _buildFilterButton(3, "Pollution"),
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
                child: Consumer<VehicleProvider>(
                  builder: (context, vehicleProvider, child) {
                    List filteredItems =
                        _filterVehicles(vehicleProvider.vehicles);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var vehicle = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleViewScreen(
                                  vehicleRegistrationNo:
                                      vehicle['registration_number'],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontSize: 19),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                            Icons.arrow_circle_right_outlined),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      vehicle['model'],
                                      style: const TextStyle(fontSize: 15),
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                        const Spacer(),
                                        Text(
                                          filterValue == 1
                                              ? vehicle['Fitness_Upto']
                                              : filterValue == 2
                                                  ? vehicle['Insurance_Upto']
                                                  : vehicle['Pollution_Upto'],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Text(
                                        "We will notify you 30 days before any validity expiry")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(int value, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterValue = value;
        });
      },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: filterValue != value
              ? Colors.white
              : const Color.fromRGBO(139, 91, 159, 1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
            child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: filterValue != value ? Colors.black : Colors.white),
        )),
      ),
    );
  }

  List _filterVehicles(Map<String, dynamic> vehicles) {
    List items = vehicles.values.toList();
    List filteredItems = [];

    if (filterValue == 1) {
      filteredItems = items.where((vehicle) {
        DateTime fitnessUptoDate =
            DateFormat('yyyy-MM-dd').parse(vehicle['Fitness_Upto']);
        DateTime now = DateTime.now().add(const Duration(days: 30));
        bool isFitnessDateBefore = fitnessUptoDate.isBefore(now);

        bool isSearchMatch = deviceSearch.isEmpty ||
            vehicle['registration_number']
                .toLowerCase()
                .replaceAll('_', ' ')
                .contains(deviceSearch.toLowerCase()) ||
            vehicle['model'].toLowerCase().contains(deviceSearch.toLowerCase());

        return isFitnessDateBefore && isSearchMatch;
      }).toList();
    } else if (filterValue == 2) {
      filteredItems = items.where((vehicle) {
        DateTime insuranceUptoDate =
            DateFormat('yyyy-MM-dd').parse(vehicle['Insurance_Upto']);
        DateTime now = DateTime.now().add(const Duration(days: 30));
        bool isInsuranceDateBefore = insuranceUptoDate.isBefore(now);
        bool isSearchMatch = deviceSearch.isEmpty ||
            vehicle['registration_number']
                .toLowerCase()
                .replaceAll('_', ' ')
                .contains(deviceSearch.toLowerCase()) ||
            vehicle['model'].toLowerCase().contains(deviceSearch.toLowerCase());
        return isInsuranceDateBefore && isSearchMatch;
      }).toList();
    } else {
      filteredItems = items.where((vehicle) {
        DateTime pollutionUptoDate =
            DateFormat('yyyy-MM-dd').parse(vehicle['Pollution_Upto']);
        DateTime now = DateTime.now().add(const Duration(days: 30));
        bool isPollutionDateBefore = pollutionUptoDate.isBefore(now);
        bool isSearchMatch = deviceSearch.isEmpty ||
            vehicle['registration_number']
                .toLowerCase()
                .replaceAll('_', ' ')
                .contains(deviceSearch.toLowerCase()) ||
            vehicle['model'].toLowerCase().contains(deviceSearch.toLowerCase());
        return isPollutionDateBefore && isSearchMatch;
      }).toList();
    }

    return filteredItems;
  }
}
