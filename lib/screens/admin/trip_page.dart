import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/admin/trip_view.dart';
import 'package:provider/provider.dart';
import 'package:insthelper/provider/map_auto_provider.dart';
import 'package:insthelper/components/location_list_tile.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  TextEditingController distanceController = TextEditingController();
  TextEditingController tripPurposeController = TextEditingController();
  TextEditingController tripTimeController = TextEditingController();
  TextEditingController tripDateController = TextEditingController();
  TextEditingController vehicleCurrentKMController = TextEditingController();
  List<TextEditingController> additionalLocationControllers = [];
  List<Map<String, dynamic>> vehicles = [];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  FocusNode startFocusNode = FocusNode();
  FocusNode endFocusNode = FocusNode();
  List<FocusNode> additionalFocusNodes = [];
  String? vehicleNumber;
  String? vehicleType;
  String? vehicleDriver;
  List<Map<String, double?>> additionalLocations = [];
  double totalDistance = 0.0;
  int selectedLocId = 0;
  FocusNode? activeFocusNode;
  List<dynamic> vehicleData = [];
  String? selectedVehicleType;
  String? selectedVehicle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().fetchTrip();
    });
    startFocusNode.addListener(() => _updateActiveFocusNode(startFocusNode));
    endFocusNode.addListener(() => _updateActiveFocusNode(endFocusNode));
    _addLocationField(0);
    _addLocationField(1);
    _addVehicle();
    Provider.of<TripProvider>(context, listen: false).fetchTrip();
  }

  @override
  void dispose() {
    for (var controller in additionalLocationControllers) {
      controller.dispose();
    }
    for (var focusNode in additionalFocusNodes) {
      focusNode.dispose();
    }
    startFocusNode.dispose();
    endFocusNode.dispose();
    super.dispose();
  }

  void _updateActiveFocusNode(FocusNode focusNode) {
    setState(() {
      activeFocusNode = focusNode;
    });
  }

  double calculateHaversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _calculateTotalDistance() {
    totalDistance = 0.0;

    for (int i = 0; i < additionalLocations.length - 1; i++) {
      if (additionalLocations[i]['lat'] != null &&
          additionalLocations[i + 1]['lat'] != null) {
        totalDistance += calculateHaversineDistance(
          additionalLocations[i]['lat']!,
          additionalLocations[i]['lng']!,
          additionalLocations[i + 1]['lat']!,
          additionalLocations[i + 1]['lng']!,
        );
      }
    }

    // Update distanceController
    distanceController.text = totalDistance.toStringAsFixed(2);
  }

  void _addLocationField(int index) {
    setState(() {
      additionalLocationControllers.insert(index, TextEditingController());
      additionalLocations.insert(index, {'lat': null, 'lng': null});
      FocusNode focusNode = FocusNode();
      focusNode.addListener(() => _updateActiveFocusNode(focusNode));
      additionalFocusNodes.insert(index, focusNode);
    });
  }

  void _removeLocationField(int index) {
    if (additionalLocations.length > 2) {
      setState(() {
        additionalLocationControllers.removeAt(index);
        additionalLocations.removeAt(index);
        additionalFocusNodes.removeAt(index).dispose();
        _calculateTotalDistance();
      });
    }
  }

  void _addVehicle() {
    setState(() {
      vehicles.add({
        'vehicleTypeController': TextEditingController(),
        'vehicleNumberController': TextEditingController(),
        'vehicleCurrentKMController': TextEditingController(),
        'vehicleDriverController': TextEditingController(),
      });
    });
  }

  void _removeVehicle(int index) {
    if (vehicles.length > 1) {
      setState(() {
        vehicles.removeAt(index);
      });
    }
  }

  void fetchVehicleDataAndUpdateLabel(String vehicleNumber, int index) {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    vehicleProvider.fetchVehicleData(vehicleNumber).then((_) {
      final vdata = vehicleProvider.specificVehicles[vehicleNumber];
      setState(() {
        vehicles[index]['vehicleData'] = vdata;
        vehicles[index]['vehicleCurrentKMController'].text =
            vdata[0]['total_km'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final tripData = tripProvider.tripData;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Filter tripData based on selectedVehicleType and selectedVehicle
    final filteredTripData = tripData.where((trip) {
      List<dynamic> vehicleIds = json.decode(trip['vehicle_id']);
      return vehicleIds.any((vehicleId) {
        var vehicle = vehicleProvider.vehicles[vehicleId.toString()];
        if (vehicle == null) return false;
        if (selectedVehicleType != null &&
            vehicle['vehicle_type'] != selectedVehicleType) return false;
        if (selectedVehicle != null &&
            vehicle['registration_number'] != selectedVehicle) return false;
        return true;
      });
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: Icon(Icons.search,
                              color: theme.colorScheme.onSurface),
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
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
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
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Icon(Icons.notifications,
                            color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter Trips:",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            "Vehicle Type",
                            selectedVehicleType,
                            [
                              null,
                              ...vehicleProvider.vehicleModels['vehicleTypes']
                                      ?.map((type) => type['type']) ??
                                  []
                            ],
                            (String? newValue) {
                              setState(() {
                                selectedVehicleType = newValue;
                                selectedVehicle =
                                    null; // Reset vehicle selection when type changes
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDropdown(
                            "Vehicle",
                            selectedVehicle,
                            [
                              null,
                              ...vehicleProvider.vehicles.values
                                  .where((v) =>
                                      selectedVehicleType == null ||
                                      v['vehicle_type'] == selectedVehicleType)
                                  .map((v) => v['registration_number'])
                            ],
                            (String? newValue) {
                              setState(() {
                                selectedVehicle = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredTripData.map((trip) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripViewScreen(
                              tripId: int.parse(trip['id']),
                              tripName: trip['purpose'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        trip['purpose'],
                                        style: theme.textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(Icons.arrow_circle_right_outlined,
                                        size: 20, color: theme.iconTheme.color),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total Vehicles: ${json.decode(trip['vehicle_id']).length}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Time: ${trip['starting_time']}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Select Trip Details",
                style: theme.textTheme.headlineSmall,
              ),
            ),
            Column(
              children: vehicles.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> vehicle = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Trip Vehicles ${index + 1}",
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Consumer<VehicleProvider>(
                                  builder: (context, vehicleProvider, child) {
                                    List<dynamic> vehicleTypesDynamic =
                                        vehicleProvider.vehicleModels[
                                                'vehicleTypes'] ??
                                            [];

                                    List<Map<String, dynamic>> vehicleTypes =
                                        vehicleTypesDynamic
                                            .map((item) =>
                                                item as Map<String, dynamic>)
                                            .toList();
                                    List<String> vehicleList = vehicleTypes
                                        .map((vehicle) =>
                                            vehicle['type'].toString())
                                        .toList();

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: theme.dividerColor,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: vehicle['vehicleTypeController']
                                                .text
                                                .isNotEmpty
                                            ? vehicle['vehicleTypeController']
                                                .text
                                            : null,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            vehicle['vehicleTypeController']
                                                .text = newValue ?? '';
                                            vehicle['vehicleNumberController']
                                                .text = '';
                                          });
                                        },
                                        onTap: () {},
                                        items: vehicleList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        hint: const Text("Select Vehicle Type"),
                                        isExpanded: true,
                                        underline: Container(),
                                        style: theme.textTheme.bodyMedium,
                                        dropdownColor: theme.cardColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Consumer<VehicleProvider>(
                                  builder: (context, vehicleProvider, child) {
                                    List<String> filteredVehicleList =
                                        vehicleProvider.vehicles.entries
                                            .where((entry) =>
                                                entry.value['vehicle_type'] ==
                                                vehicle['vehicleTypeController']
                                                    .text)
                                            .map((entry) => entry
                                                .value['registration_number']
                                                .toString())
                                            .toList();

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.dividerColor,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.directions_car,
                                              color: theme.iconTheme.color),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: vehicle[
                                                            'vehicleNumberController']
                                                        .text
                                                        .isNotEmpty
                                                    ? vehicle[
                                                            'vehicleNumberController']
                                                        .text
                                                    : null,
                                                hint: const Text(
                                                    'Select Vehicle'),
                                                items: filteredVehicleList
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value.replaceAll(
                                                          '_', ' '),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    vehicle['vehicleNumberController']
                                                        .text = newValue ?? '';

                                                    fetchVehicleDataAndUpdateLabel(
                                                        vehicle['vehicleNumberController']
                                                            .text!
                                                            .replaceAll(
                                                                " ", "_"),
                                                        index);
                                                  });
                                                },
                                                style:
                                                    theme.textTheme.bodyMedium,
                                                dropdownColor: theme.cardColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Consumer<VehicleProvider>(
                                  builder: (context, vehicleProvider, child) {
                                    List<dynamic> vehicleDriversDynamic =
                                        vehicleProvider.vehicleDrivers[
                                                'vehicleDrivers'] ??
                                            [];

                                    List<Map<String, dynamic>> vehicleDrivers =
                                        vehicleDriversDynamic
                                            .map((item) =>
                                                item as Map<String, dynamic>)
                                            .toList();
                                    List<String> vehicleList = vehicleDrivers
                                        .map((vehicle) =>
                                            vehicle['name'].toString())
                                        .toList();

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.dividerColor,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: theme.iconTheme.color),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: vehicle[
                                                            'vehicleDriverController']
                                                        .text
                                                        .isNotEmpty
                                                    ? vehicle[
                                                            'vehicleDriverController']
                                                        .text
                                                    : null,
                                                hint: const Text('Driver'),
                                                items: vehicleList
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: SizedBox(
                                                      width:
                                                          150, // Adjust this value as needed
                                                      child: Text(
                                                        value.replaceAll(
                                                            '_', ' '),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    vehicle['vehicleDriverController']
                                                        .text = newValue ?? '';
                                                  });
                                                },
                                                isExpanded: true,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                                dropdownColor: theme.cardColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: theme.dividerColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller:
                                        vehicle['vehicleCurrentKMController'],
                                    decoration: InputDecoration(
                                      hintText: "Current KM",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                    ),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.add, color: theme.iconTheme.color),
                              onPressed: _addVehicle,
                            ),
                            if (vehicles.length >
                                1) // Only show remove button if there's more than one vehicle
                              IconButton(
                                icon: Icon(Icons.remove,
                                    color: theme.iconTheme.color),
                                onPressed: () => _removeVehicle(index),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trip Locations",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...additionalLocationControllers
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;

                      return Consumer<MapAuto>(
                        builder: (context, mapAuto, child) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        onChanged: (value) {
                                          selectedLocId = index + 1;
                                          context
                                              .read<MapAuto>()
                                              .placeAutoComplete(value);
                                          // Wait for the place details to update and then recalculate distance
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            _calculateTotalDistance();
                                          });
                                        },
                                        controller: controller,
                                        focusNode: additionalFocusNodes[index],
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          prefixIcon: Icon(
                                              Icons.share_location_sharp,
                                              color: theme.iconTheme.color),
                                          hintText:
                                              'Additional Locations ${index + 1}',
                                          hintStyle: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.add_circle,
                                            color: theme.iconTheme.color),
                                        onPressed: () {
                                          _addLocationField(index + 1);
                                          _calculateTotalDistance();
                                        }),
                                    additionalLocations.length > 2
                                        ? IconButton(
                                            icon: Icon(Icons.remove_circle,
                                                color: theme.iconTheme.color),
                                            onPressed: () {
                                              _removeLocationField(index);
                                              _calculateTotalDistance();
                                            })
                                        : Container(),
                                  ],
                                ),
                              ),
                              if (mapAuto.predictions.isNotEmpty &&
                                  activeFocusNode ==
                                      additionalFocusNodes[index])
                                Container(
                                  color: theme.cardColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    children: List.generate(
                                        mapAuto.predictions.length, (i) {
                                      final location = mapAuto.predictions[i];
                                      return LocationListTile(
                                        location: location['description'] ??
                                            'No description',
                                        press: () async {
                                          final placeDetails =
                                              await mapAuto.getPlaceDetails(
                                                  location['place_id']);
                                          if (placeDetails != null) {
                                            controller.text =
                                                location['description'];
                                            additionalLocations[index] = {
                                              'lat': placeDetails['lat'],
                                              'lng': placeDetails['lng'],
                                            };
                                            _calculateTotalDistance();
                                          }
                                          context
                                              .read<MapAuto>()
                                              .placeAutoComplete("");
                                        },
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: distanceController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon:
                              Icon(Icons.route, color: theme.iconTheme.color),
                          labelText: 'Trip Distance',
                          labelStyle: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormInputField(
                        textcontroller: tripPurposeController,
                        label: "Purpose",
                        validator: false,
                        icon: Icon(Icons.sms, color: theme.iconTheme.color),
                        regex: RegExp("source"),
                        regexlabel: "",
                        numberkeyboard: false,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FormField<DateTime>(
                              builder: (FormFieldState<DateTime> state) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedStartDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null &&
                                        picked != state.value) {
                                      setState(() {
                                        selectedStartDate = picked;
                                      });
                                      state.didChange(picked);
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Start Date',
                                      border: const OutlineInputBorder(),
                                      errorText: state.errorText,
                                      labelStyle: theme.textTheme.bodyMedium,
                                    ),
                                    child: Text(
                                      selectedStartDate == null
                                          ? 'Select Start Date'
                                          : '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                );
                              },
                              initialValue: selectedStartDate,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a start date.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: FormField<DateTime>(
                              builder: (FormFieldState<DateTime> state) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedEndDate ??
                                          (selectedStartDate ?? DateTime.now()),
                                      firstDate:
                                          selectedStartDate ?? DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null &&
                                        picked != state.value) {
                                      setState(() {
                                        selectedEndDate = picked;
                                      });
                                      state.didChange(picked);
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'End Date',
                                      border: const OutlineInputBorder(),
                                      errorText: state.errorText,
                                      labelStyle: theme.textTheme.bodyMedium,
                                    ),
                                    child: Text(
                                      selectedEndDate == null
                                          ? 'Select End Date'
                                          : '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                );
                              },
                              initialValue: selectedEndDate,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an end date.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    bool isValid = true; // Flag to track if the form is valid

                    // Check if all vehicle fields are filled
                    for (var vehicle in vehicles) {
                      if (vehicle['vehicleNumberController'].text.isEmpty ||
                          vehicle['vehicleDriverController'].text.isEmpty ||
                          vehicle['vehicleCurrentKMController'].text.isEmpty) {
                        isValid = false;
                        Fluttertoast.showToast(
                            msg: "Please fill out all vehicle fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        break;
                      }
                    }

                    // Check if all additional locations are filled
                    for (var locationController
                        in additionalLocationControllers) {
                      if (locationController.text.isEmpty) {
                        isValid = false;
                        Fluttertoast.showToast(
                            msg: "Please fill out all location fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        break;
                      }
                    }

                    // Check if trip purpose is filled
                    if (tripPurposeController.text.isEmpty) {
                      isValid = false;
                      Fluttertoast.showToast(
                          msg: "Please enter the trip purpose",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    // Check if start date is selected
                    if (selectedStartDate == null) {
                      isValid = false;
                      Fluttertoast.showToast(
                          msg: "Please select a start date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    // Check if end date is selected
                    if (selectedEndDate == null) {
                      isValid = false;
                      Fluttertoast.showToast(
                          msg: "Please select an end date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    // Check if end date is after start date
                    if (selectedStartDate != null &&
                        selectedEndDate != null &&
                        selectedEndDate!.isBefore(selectedStartDate!)) {
                      isValid = false;
                      Fluttertoast.showToast(
                          msg: "End date must be after start date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    // Check if time is selected

                    // If all fields are valid, proceed with submitting the form
                    if (isValid) {
                      List<String> numbers = [];
                      List<String> drivers = [];
                      List<String> totalKm = [];
                      List<String> locations = [];

                      for (var vehicle in vehicles) {
                        numbers.add(vehicle['vehicleNumberController'].text);
                        drivers.add(vehicle['vehicleDriverController'].text);
                        totalKm.add(vehicle['vehicleCurrentKMController'].text);
                      }
                      for (var location in additionalLocationControllers) {
                        locations.add(location.text);
                      }

                      TripProvider().addTrip(
                          numbers,
                          drivers,
                          totalKm,
                          locations,
                          tripPurposeController.text,
                          selectedStartDate!,
                          selectedEndDate!);

                      Fluttertoast.showToast(
                          msg: "Trip added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // Clear all the fields
                      for (var vehicle in vehicles) {
                        vehicle['vehicleNumberController'].clear();
                        vehicle['vehicleDriverController'].clear();
                        vehicle['vehicleCurrentKMController'].clear();
                      }

                      for (var locationController
                          in additionalLocationControllers) {
                        locationController.clear();
                      }

                      tripPurposeController.clear();
                      selectedStartDate = null;
                      selectedEndDate = null;

                      setState(() {
                        // Reset the focus nodes and any other stateful widgets if necessary
                        additionalLocationControllers.clear();
                        distanceController.clear();
                        additionalFocusNodes.clear();
                        additionalLocations.clear();
                        vehicles.clear(); // Clear the vehicle list if needed
                      });
                      _addLocationField(0);
                      _addLocationField(1);
                      _addVehicle();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    textStyle: theme.textTheme.labelLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Add Trip"),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String?> items,
      void Function(String?) onChanged) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: theme.dividerColor,
          width: 1.0,
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item ?? "All ${label}s"),
          );
        }).toList(),
        isExpanded: true,
        underline: Container(),
        hint: Text("Select $label"),
        style: theme.textTheme.bodyMedium,
        dropdownColor: theme.cardColor,
      ),
    );
  }
}
