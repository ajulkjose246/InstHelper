import 'dart:math';
import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  TextEditingController timeController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  String? vehicleType;
  String? startingLocation;
  String? endingLocation;
  double? distance;
  int? startingLocationId;
  int? endingLocationId;
  var filterValue = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().fetchTrip();
    });
  }

  @override
  void dispose() {
    timeController.dispose();
    distanceController.dispose();
    super.dispose();
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
    var km = R * c;
    distanceController.text = "${km.toStringAsFixed(2)} KM";
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _calculateDistance() {
    final vehicleProvider = context.read<VehicleProvider>();
    final locations = vehicleProvider.locations['locations'] ?? [];

    if (startingLocationId != null && endingLocationId != null) {
      final startLocation = locations.firstWhere(
        (loc) => loc['id'] == startingLocationId.toString(),
        orElse: () => null,
      );

      final endLocation = locations.firstWhere(
        (loc) => loc['id'] == endingLocationId.toString(),
        orElse: () => null,
      );

      if (startLocation != null && endLocation != null) {
        distance = calculateHaversineDistance(
            double.parse(startLocation['latitude']),
            double.parse(startLocation['longitude']),
            double.parse(endLocation['latitude']),
            double.parse(endLocation['longitude']));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 245, 1),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton(1, "Add Trip"),
                const SizedBox(width: 10),
                _buildFilterButton(2, "List Trip"),
              ],
            ),
          ),
          filterValue == 1
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Select Trip Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Consumer<VehicleProvider>(
                            builder: (context, vehicleProvider, child) {
                              List<String> vehicleList =
                                  vehicleProvider.vehicles.keys.toList();
                              final locations =
                                  vehicleProvider.locations['locations'] ?? [];
                              final locationMap = {
                                for (var loc in locations)
                                  loc['name']: int.parse(loc['id'])
                              };

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
                                          value: vehicleType,
                                          hint: const Text('Select Vehicle'),
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
                                              vehicleType = newValue;
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
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: FormInputField(
                                textcontroller: timeController,
                                label: "Starting Time",
                                validator: false,
                                icon: Icon(Icons.timer_outlined),
                                regex: RegExp("source"),
                                regexlabel: "",
                                numberkeyboard: false)),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Consumer<VehicleProvider>(
                                          builder: (context, vehicleProvider,
                                              child) {
                                            final locations = vehicleProvider
                                                    .locations['locations'] ??
                                                [];
                                            final locationMap = {
                                              for (var loc in locations)
                                                loc['name']:
                                                    int.parse(loc['id'])
                                            };
                                            return DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: startingLocation,
                                                hint: const Text('Start Point'),
                                                items: locations.map<
                                                    DropdownMenuItem<
                                                        String>>((vehicle) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: vehicle['name'],
                                                    child:
                                                        Text(vehicle['name']),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    startingLocation = newValue;
                                                    startingLocationId =
                                                        locationMap[newValue];
                                                    _calculateDistance(); // Calculate distance when start point changes
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.east),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Consumer<VehicleProvider>(
                                          builder: (context, vehicleProvider,
                                              child) {
                                            final locations = vehicleProvider
                                                    .locations['locations'] ??
                                                [];
                                            final locationMap = {
                                              for (var loc in locations)
                                                loc['name']:
                                                    int.parse(loc['id'])
                                            };
                                            return DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: endingLocation,
                                                hint:
                                                    const Text('Ending Point'),
                                                items: locations.map<
                                                    DropdownMenuItem<
                                                        String>>((vehicle) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: vehicle['name'],
                                                    child:
                                                        Text(vehicle['name']),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    endingLocation = newValue;
                                                    endingLocationId =
                                                        locationMap[newValue];
                                                    _calculateDistance(); // Calculate distance when end point changes
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: TextFormField(
                            controller: distanceController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: Icon(Icons.route),
                              hintText:
                                  'Distance (km)', // Added hint text for clarity
                            ),
                            readOnly: true, // Make the distance field read-only
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  vehicleType = null;
                                  timeController.clear();
                                  distanceController.clear();
                                  setState(() {
                                    startingLocation = null;
                                    endingLocation = null;
                                    startingLocationId = null;
                                    endingLocationId = null;
                                    distance = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  "Reset",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  TripProvider().addTrip(
                                      vehicleType!.replaceAll(' ', '_'),
                                      timeController,
                                      startingLocationId!,
                                      endingLocationId!);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Consumer<TripProvider>(
                    builder: (context, tripProvider, child) {
                      final trips = tripProvider.tripData['tripData'] ?? [];
                      return ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${trip['vehicle_id'].replaceAll('_', ' ')}',
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Total KM: ${trip['distance'] ?? 'N/A'}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 47, 27, 27),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Start Time: ${trip['starting_time']}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        'From: ${trip['start_point_name']}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        'To: ${trip['end_point_name']}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
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
              color: filterValue != value ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
