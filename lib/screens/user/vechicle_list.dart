import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/functions/home_screen_function.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:provider/provider.dart';
import 'vehicle_view.dart';

class VechicleListScreen extends StatefulWidget {
  const VechicleListScreen({super.key});

  @override
  State<VechicleListScreen> createState() => _VechicleListScreenState();
}

class _VechicleListScreenState extends State<VechicleListScreen> {
  var deviceSearch = '';

  @override
  Widget build(BuildContext context) {
    return Container(
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context
                        .read<HomescreenProvider>()
                        .updateMyVariable(newValue: 4);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
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
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
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

                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  List items = [];

                  data.forEach((key, value) {
                    items.add({"key": key, ...value});
                  });

                  // Filter items based on search criteria
                  List filteredItems = items.where((vehicle) {
                    return deviceSearch.isEmpty ||
                        vehicle['Registration Number']
                            .toLowerCase()
                            .replaceAll('_', ' ')
                            .contains(deviceSearch.toLowerCase()) ||
                        vehicle['Model']
                            .toLowerCase()
                            .contains(deviceSearch.toLowerCase());
                  }).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
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
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ));
                          } else if (snapshot.hasError) {
                            return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ));
                          } else {
                            var imageData = snapshot.data as String;
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VehicleViewScreen(
                                        vehicleRegistrationNo:
                                            vehicle['Registration Number'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vehicle['Registration Number']
                                              .toString()
                                              .toUpperCase()
                                              .replaceAll('_', ' '),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                        Text(
                                          vehicle['Model'],
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        Expanded(
                                          child: imageData.isNotEmpty
                                              ? Image.network(
                                                  imageData,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return const Center(
                                                      child: Icon(Icons.error),
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/img/car.png',
                                                  fit: BoxFit.contain,
                                                ),
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
                  );
                }

                return const Center(child: Text('No data available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
