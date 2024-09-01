import 'package:flutter/material.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:AjceTrips/screens/normal/vehicle_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NormalAlertList extends StatefulWidget {
  const NormalAlertList({super.key});

  @override
  State<NormalAlertList> createState() => _NormalAlertListState();
}

class _NormalAlertListState extends State<NormalAlertList> {
  var filterValue = 1;
  String deviceSearch = '';

  @override
  Widget build(BuildContext context) {
    print("Normal alert list");
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    if (vehicleProvider.vehicles.isEmpty) {
      vehicleProvider.fetchAllVehicleData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).colorScheme.onSurface),
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
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        vehicle['registration_number']
                                            .toString()
                                            .toUpperCase()
                                            .replaceAll('_', ' '),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    vehicle['model'],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filterValue == 1
                                            ? "Fitness"
                                            : filterValue == 2
                                                ? "Insurance"
                                                : "Pollution",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      Text(
                                        filterValue == 1
                                            ? _formatDate(
                                                vehicle['Fitness_Upto'])
                                            : filterValue == 2
                                                ? _formatDate(
                                                    vehicle['Insurance_Upto'])
                                                : _formatDate(
                                                    vehicle['Pollution_Upto']),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Expires in ${_getDaysUntilExpiry(vehicle)} days",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
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
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: filterValue != value
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
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

  String _formatDate(String dateString) {
    final inputDate = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('dd-MMM-yyyy').format(inputDate);
  }

  int _getDaysUntilExpiry(Map<String, dynamic> vehicle) {
    String dateString = filterValue == 1
        ? vehicle['Fitness_Upto']
        : filterValue == 2
            ? vehicle['Insurance_Upto']
            : vehicle['Pollution_Upto'];
    DateTime expiryDate = DateFormat('yyyy-MM-dd').parse(dateString);
    return expiryDate.difference(DateTime.now()).inDays;
  }
}
