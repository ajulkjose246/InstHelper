import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:AjceTrips/components/trip_update_popup_message.dart'; // Add this import

class TripViewScreen extends StatefulWidget {
  final int tripId;
  final String tripName;

  const TripViewScreen({
    Key? key,
    required this.tripId,
    required this.tripName,
  }) : super(key: key);

  @override
  State<TripViewScreen> createState() => _TripViewScreenState();
}

class _TripViewScreenState extends State<TripViewScreen> {
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: Consumer<TripProvider>(
        builder: (context, provider, child) {
          provider.fetchSpecificTrip(widget.tripId);
          final data = provider.tripSpecificData;

          if (data.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final tripData = data[0];
          final vehicleNumbers = json.decode(tripData['vehicle_id']);
          final vehicleDrivers = json.decode(tripData['driver']);
          final vehicleStartingKm = json.decode(tripData['starting_km']);
          final vehicleEndingKm = json.decode(tripData['ending_km']);
          final tripLocations = json.decode(tripData['route']);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              title: Text(
                widget.tripName.replaceAll('_', ' '),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripDetailsCard(tripData),
                    const SizedBox(height: 16),
                    _buildVehicleDetailsCard(vehicleNumbers, vehicleDrivers,
                        vehicleStartingKm, vehicleEndingKm),
                    const SizedBox(height: 16),
                    _buildLocationDetailsCard(tripLocations),
                  ],
                ),
              ),
            ),
            floatingActionButton: _buildSpeedDial(context, tripData),
          );
        },
      ),
    );
  }

  Widget _buildTripDetailsCard(Map<String, dynamic> tripData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trip Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showUpdateDialog(context, 1, tripData),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Purpose", tripData['purpose']),
            _buildInfoRow("Start Date", _formatDate(tripData['starting_date'])),
            _buildInfoRow("End Date", _formatDate(tripData['ending_date'])),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsCard(List vehicleNumbers, List vehicleDrivers,
      List vehicleStartingKm, List vehicleEndingKm) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vehicle Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showUpdateDialog(context, 2, {
                    'vehicle_id': vehicleNumbers,
                    'driver': vehicleDrivers,
                    'starting_km': vehicleStartingKm,
                    'ending_km': vehicleEndingKm,
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < vehicleNumbers.length; i++) ...[
              if (i > 0) const Divider(height: 32),
              Text(
                "Vehicle ${i + 1}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                  "Registration", vehicleNumbers[i].replaceAll("_", " ")),
              _buildInfoRow("Driver", vehicleDrivers[i]),
              _buildInfoRow("Starting KM", vehicleStartingKm[i]),
              _buildInfoRow("Ending KM", vehicleEndingKm[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsCard(List tripLocations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      _showUpdateDialog(context, 3, {'route': tripLocations}),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < tripLocations.length; i++)
              _buildInfoRow("Location ${i + 1}", tripLocations[i]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial(BuildContext context, Map<String, dynamic> tripData) {
    return SpeedDial(
      icon: Icons.more_vert,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      children: [
        SpeedDialChild(
          child: Icon(LineIcons.share,
              color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onTap: () => _shareTrip(tripData),
        ),
        SpeedDialChild(
          child: Icon(LineIcons.trash,
              color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onTap: () => _deleteTrip(context, tripData),
        ),
      ],
    );
  }

  void _showUpdateDialog(
      BuildContext context, int type, Map<String, dynamic> tripData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TripUpdateMessage(
          type: type,
          tripId: widget.tripId,
          tripData: tripData,
        );
      },
    );
  }

  void _shareTrip(Map<String, dynamic> tripData) {
    final vehicleNumbers = json.decode(tripData['vehicle_id']);
    final vehicleDrivers = json.decode(tripData['driver']);
    final vehicleStartingKm = json.decode(tripData['starting_km']);
    final vehicleEndingKm = json.decode(tripData['ending_km']);
    final tripLocations = json.decode(tripData['route']);

    String shareText = '''
Trip Details:
Name: ${widget.tripName.replaceAll('_', ' ')}
Purpose: ${tripData['purpose']}
Start Date: ${_formatDate(tripData['starting_date'])}
End Date: ${_formatDate(tripData['ending_date'])}

Vehicle Details:
''';

    for (int i = 0; i < vehicleNumbers.length; i++) {
      shareText += '''
Vehicle ${i + 1}:
  Registration: ${vehicleNumbers[i].replaceAll("_", " ")}
  Driver: ${vehicleDrivers[i]}
  Starting KM: ${vehicleStartingKm[i]}
  Ending KM: ${vehicleEndingKm[i]}
''';
    }

    shareText += '\nLocations:\n';
    for (int i = 0; i < tripLocations.length; i++) {
      shareText += '  ${i + 1}. ${tripLocations[i]}\n';
    }

    Share.share(shareText);
  }

  void _deleteTrip(BuildContext context, Map<String, dynamic> tripData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this trip?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<TripProvider>(context, listen: false)
                    .deleteTrip(tripData['id']);
                Fluttertoast.showToast(
                  msg: "Trip deleted successfully",
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
