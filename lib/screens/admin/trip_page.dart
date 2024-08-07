import 'dart:math';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:insthelper/provider/map_auto_provider.dart';
import 'package:insthelper/components/location_list_tile.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  TextEditingController startPointController = TextEditingController();
  TextEditingController endPointController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController tripPurposeController = TextEditingController();
  TextEditingController tripTimeController = TextEditingController();
  TextEditingController tripDateController = TextEditingController();
  TextEditingController vehicleCurrentKMController = TextEditingController();
  List<TextEditingController> additionalLocationControllers = [];
  List<Map<String, dynamic>> vehicles = [];

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
  }

  @override
  void dispose() {
    startPointController.dispose();
    endPointController.dispose();
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
        // Debugging print statements
        print('Location $i: ${additionalLocations[i]}');
        print('Location ${i + 1}: ${additionalLocations[i + 1]}');

        totalDistance += calculateHaversineDistance(
          additionalLocations[i]['lat']!,
          additionalLocations[i]['lng']!,
          additionalLocations[i + 1]['lat']!,
          additionalLocations[i + 1]['lng']!,
        );
      }
    }

    // Update distanceController
    distanceController.text = "${totalDistance.toStringAsFixed(2)} KM";
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
            "${vdata[0]['total_km'].toString()} KM";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 245, 1),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
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
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Select Trip Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
        // for (int i = 0; i < vehicles.length; i++)
        Column(
          children: vehicles.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> vehicle = entry.value;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Consumer<VehicleProvider>(
                              builder: (context, vehicleProvider, child) {
                                List<dynamic> vehicleTypesDynamic =
                                    vehicleProvider
                                            .vehicleModels['vehicleTypes'] ??
                                        [];

                                List<Map<String, dynamic>> vehicleTypes =
                                    vehicleTypesDynamic
                                        .map((item) =>
                                            item as Map<String, dynamic>)
                                        .toList();
                                List<String> vehicleList = vehicleTypes
                                    .map(
                                        (vehicle) => vehicle['type'].toString())
                                    .toList();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          204, 204, 204, 1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: vehicle['vehicleTypeController']
                                            .text
                                            .isNotEmpty
                                        ? vehicle['vehicleTypeController'].text
                                        : null,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        vehicle['vehicleTypeController'].text =
                                            newValue ?? '';
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
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.directions_car),
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
                                            hint: const Text('Select Vehicle'),
                                            items: filteredVehicleList
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value.replaceAll('_', ' ')),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                vehicle['vehicleNumberController']
                                                    .text = newValue ?? '';

                                                fetchVehicleDataAndUpdateLabel(
                                                    vehicle['vehicleNumberController']
                                                        .text!
                                                        .replaceAll(" ", "_"),
                                                    index);
                                              });
                                            },
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
                                    vehicleProvider
                                            .vehicleDrivers['vehicleDrivers'] ??
                                        [];

                                List<Map<String, dynamic>> vehicleDrivers =
                                    vehicleDriversDynamic
                                        .map((item) =>
                                            item as Map<String, dynamic>)
                                        .toList();
                                List<String> vehicleList = vehicleDrivers
                                    .map(
                                        (vehicle) => vehicle['name'].toString())
                                    .toList();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person),
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
                                            items:
                                                vehicleList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    value.replaceAll('_', ' ')),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                vehicle['vehicleDriverController']
                                                    .text = newValue ?? '';
                                              });
                                            },
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
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TextFormField(
                                controller:
                                    vehicle['vehicleCurrentKMController'],
                                decoration: InputDecoration(
                                  hintText: "Current KM",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(204, 204, 204, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addVehicle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
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
          child: Column(
            children: [
              ...additionalLocationControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;

                return Consumer<MapAuto>(
                  builder: (context, mapAuto, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.share_location_sharp),
                                    hintText:
                                        'Additional Locations ${index + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    _addLocationField(index + 1);
                                    _calculateTotalDistance();
                                  }),
                              additionalLocations.length > 2
                                  ? IconButton(
                                      icon: const Icon(Icons.remove_circle),
                                      onPressed: () {
                                        _removeLocationField(index);
                                        _calculateTotalDistance();
                                      })
                                  : Container(),
                            ],
                          ),
                        ),
                        if (mapAuto.predictions.isNotEmpty &&
                            activeFocusNode == additionalFocusNodes[index])
                          Container(
                            color: Colors.white,
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
                                    final placeDetails = await mapAuto
                                        .getPlaceDetails(location['place_id']);
                                    if (placeDetails != null) {
                                      controller.text = location['description'];
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: distanceController,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              prefixIcon: Icon(Icons.route),
              labelText: 'Trip Distance',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FormInputField(
              textcontroller: tripPurposeController,
              label: "Purpose",
              validator: false,
              icon: const Icon(Icons.sms),
              regex: RegExp("source"),
              regexlabel: "",
              numberkeyboard: false),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Reset"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Add"),
            ),
            const Spacer(),
          ],
        ),
      ])),
    );
  }
}
