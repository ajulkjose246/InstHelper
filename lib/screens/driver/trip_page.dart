import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/screens/driver/trip_view.dart';
import 'package:provider/provider.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().fetchTrip();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    final tripData = tripProvider.tripData;

    // Filter trips where the driver contains "Ajul"
    final filteredTripData = tripData.where((trip) {
      final driver = trip['driver'] ?? '';
      return driver.contains('Ajul');
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 245, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10), // Add space between header and list
            _buildTripList(filteredTripData), // Use filtered data
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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
              context.read<HomescreenProvider>().updateMyVariable(newValue: 3);
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
    );
  }

  Widget _buildSearchBar() {
    return Expanded(
      child: Container(
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
            context.read<HomescreenProvider>().updateMyVariable(newValue: 1);
          },
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        context.read<HomescreenProvider>().updateMyVariable(newValue: 3);
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
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
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
    );
  }

  Widget _buildTripList(List<dynamic> tripData) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: tripData.map((trip) {
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
              padding:
                  const EdgeInsets.only(bottom: 10), // Add space between items
              child: Container(
                height: 120,
                width: double.infinity, // Full width
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              trip['purpose'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_circle_right_outlined),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Vehicles: ${json.decode(trip['vehicle_id']).length}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Time: ${trip['starting_time']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}