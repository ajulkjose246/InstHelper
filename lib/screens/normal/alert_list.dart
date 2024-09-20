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

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    // Adjust base font size based on screen width
    double baseFontSize = screenWidth < 360 ? 14 : 16;

    // Apply text scale factor and limit maximum size more strictly
    double titleFontSize =
        (baseFontSize * 1.2 / textScaleFactor).clamp(14.0, 20.0);
    double bodyFontSize = (baseFontSize / textScaleFactor).clamp(12.0, 16.0);
    double smallFontSize =
        (baseFontSize * 0.8 / textScaleFactor).clamp(10.0, 14.0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts",
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
            )),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterButton(1, "Fitness", smallFontSize),
                  SizedBox(width: screenWidth * 0.02),
                  _buildFilterButton(2, "Insurance", smallFontSize),
                  SizedBox(width: screenWidth * 0.02),
                  _buildFilterButton(3, "Pollution", smallFontSize),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: bodyFontSize),
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
                padding: EdgeInsets.all(screenWidth * 0.02),
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
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.01),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.03),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: bodyFontSize),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: bodyFontSize,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    vehicle['model'],
                                    style: TextStyle(
                                        fontSize: smallFontSize,
                                        color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
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
                                            fontSize: smallFontSize,
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
                                            fontSize: smallFontSize,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    "Expires in ${_getDaysUntilExpiry(vehicle)} days",
                                    style: TextStyle(
                                        fontSize: smallFontSize * 0.9,
                                        color: Colors.grey[600]),
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

  Widget _buildFilterButton(int value, String label, double fontSize) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterValue = value;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.29,
        height: MediaQuery.of(context).size.height * 0.05,
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
              fontSize: fontSize * 1.2, // Reduced font size by 20%
              color: Theme.of(context).colorScheme.inversePrimary,
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
