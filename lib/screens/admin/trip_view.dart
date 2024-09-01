import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TripViewScreen extends StatefulWidget {
  final int tripId;
  final String tripName;

  const TripViewScreen({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  State<TripViewScreen> createState() => _TripViewScreenState();
}

class _TripViewScreenState extends State<TripViewScreen> {
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}-${_getMonthAbbreviation(date.month)}-${date.year}";
  }

  String _getMonthAbbreviation(int month) {
    const monthAbbreviations = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthAbbreviations[month - 1];
  }

  List data = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            widget.tripName.replaceAll('_', ' '),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<TripProvider>(
          builder: (context, provider, child) {
            provider.fetchSpecificTrip(widget.tripId);
            data = provider.tripSpecificData;

            if (data.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List vehicleNumber = json.decode(data[0]['vehicle_id']);
              List vehicleDrivers = json.decode(data[0]['driver']);
              List vehicleStartingKm = json.decode(data[0]['starting_km']);
              List vehicleEndingKm = json.decode(data[0]['ending_km']);
              List tripLocations = json.decode(data[0]['route']);

              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  children: [
                    _buildInfoCard(context, "Trip Details", [
                      _buildInfoRow(context, "Purpose", data[0]['purpose']),
                      _buildInfoRow(context, "Date",
                          _formatDate(data[0]['starting_date'])),
                      _buildInfoRow(context, "Return",
                          _formatDate(data[0]['ending_date'])),
                    ]),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                        context,
                        "Vehicle Details",
                        List.generate(
                            vehicleNumber.length,
                            (index) => Column(
                                  children: [
                                    _buildInfoRow(
                                        context,
                                        "Vehicle ${index + 1}",
                                        vehicleNumber[index]
                                            .replaceAll("_", " ")),
                                    _buildInfoRow(context, "Driver",
                                        vehicleDrivers[index]),
                                    _buildInfoRow(context, "Starting KM",
                                        vehicleStartingKm[index]),
                                    _buildInfoRow(context, "Ending KM",
                                        vehicleEndingKm[index]),
                                    if (index < vehicleNumber.length - 1)
                                      const Divider(),
                                  ],
                                ))),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                        context,
                        "Location Details",
                        List.generate(
                            tripLocations.length,
                            (index) => _buildInfoRow(
                                context,
                                "Location ${index + 1}",
                                tripLocations[index]))),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: _buildSpeedDial(context, data),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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

  Widget _buildSpeedDial(BuildContext context, List data) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      children: [
        SpeedDialChild(
          child: Icon(LineIcons.share,
              color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onTap: () => _shareTrip(data),
        ),
        SpeedDialChild(
          child: Icon(LineIcons.trash,
              color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onTap: () => _deleteTrip(context, data),
        ),
      ],
    );
  }

  void _shareTrip(List data) {
    if (data.isNotEmpty) {
      List vehicleNumber = json.decode(data[0]['vehicle_id']);
      List vehicleDrivers = json.decode(data[0]['driver']);
      List starting_km = json.decode(data[0]['starting_km']);
      List tripLocations = json.decode(data[0]['route']);
      String startingDate = _formatDate(data[0]['starting_date']);
      String ending_date = _formatDate(data[0]['ending_date']);
      String purpose = data[0]['purpose'];

      // Format the details to be shared
      String shareContent = 'Trip Details\n----------------\n'
          'Date: $startingDate\n'
          'Return: $ending_date\n'
          'Purpose: $purpose\n\n'
          'Vehicle Details\n----------------\n';

      for (int i = 0; i < vehicleNumber.length; i++) {
        shareContent +=
            'Vehicle ${i + 1}: ${vehicleNumber[i].replaceAll("_", " ")}\n'
            'Driver: ${vehicleDrivers[i]}\n'
            'Starting KM: ${starting_km[i]}\n\n';
      }

      shareContent += 'Location Details\n----------------\n';
      for (int i = 0; i < tripLocations.length; i++) {
        shareContent += 'Location ${i + 1}: ${tripLocations[i]}\n';
      }

      Share.share(
        shareContent,
        subject: 'Trip Details for ${widget.tripName.replaceAll('_', ' ')}',
      ).then((result) {
        if (result.status == ShareResultStatus.success) {
          Fluttertoast.showToast(
            msg: "Trip details shared successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed to share trip details",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    }
  }

  void _deleteTrip(BuildContext context, List data) {
    if (data.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this trip?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  TripProvider().deleteTrip(data[0]['id']);
                  Fluttertoast.showToast(
                    msg: "Trip deleted successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
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
}
