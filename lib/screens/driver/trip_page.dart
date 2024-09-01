import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AjceTrips/provider/homescreen_provider.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:AjceTrips/screens/driver/trip_view.dart';
import 'package:provider/provider.dart';
import 'package:AjceTrips/provider/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final tripData = tripProvider.tripData;

    // Filter trips where the driver contains "Ajul"
    final filteredTripData = tripData.where((trip) {
      final driver = trip['driver'] ?? '';
      return driver.contains('Ajul');
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10), // Add space between header and list
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "My Trip List",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
            ),
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
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.onSurface),
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
              context.read<HomescreenProvider>().updateMyVariable(newValue: 3);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  FirebaseAuth.instance.currentUser?.photoURL != null
                      ? FirebaseAuth.instance.currentUser!.photoURL!
                      : 'assets/img/demo.jpg',
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
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Icon(Icons.notifications,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ),
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
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_circle_right_outlined),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Vehicles: ${json.decode(trip['vehicle_id']).length}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Time: ${trip['starting_time']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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
