import 'package:flutter/material.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TripUpdateMessage extends StatefulWidget {
  const TripUpdateMessage({
    Key? key,
    required this.type,
    required this.tripId,
    required this.tripData,
  }) : super(key: key);

  final int type;
  final int tripId;
  final Map<String, dynamic> tripData;

  @override
  State<TripUpdateMessage> createState() => _TripUpdateMessageState();
}

class _TripUpdateMessageState extends State<TripUpdateMessage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController purposeController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  List<TextEditingController> vehicleControllers = [];
  List<TextEditingController> driverControllers = [];
  List<TextEditingController> startKmControllers = [];
  List<TextEditingController> endKmControllers = [];

  List<TextEditingController> locationControllers = [];

  @override
  void initState() {
    super.initState();
    purposeController = TextEditingController(text: widget.tripData['purpose']);
    startDateController =
        TextEditingController(text: widget.tripData['starting_date']);
    endDateController =
        TextEditingController(text: widget.tripData['ending_date']);

    if (widget.type == 2) {
      List vehicles = widget.tripData['vehicle_id'];
      List drivers = widget.tripData['driver'];
      List startKms = widget.tripData['starting_km'];
      List endKms = widget.tripData['ending_km'];

      for (int i = 0; i < vehicles.length; i++) {
        vehicleControllers.add(TextEditingController(text: vehicles[i]));
        driverControllers.add(TextEditingController(text: drivers[i]));
        startKmControllers.add(TextEditingController(text: startKms[i]));
        endKmControllers.add(TextEditingController(text: endKms[i]));
      }
    }

    if (widget.type == 3) {
      List locations = widget.tripData['route'];
      for (String location in locations) {
        locationControllers.add(TextEditingController(text: location));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDialogTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFormFields(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text('Update'),
                      onPressed: () => _updateTrip(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDialogTitle() {
    switch (widget.type) {
      case 1:
        return "Update Trip Details";
      case 2:
        return "Update Vehicle Details";
      case 3:
        return "Update Location Details";
      default:
        return "Update Trip";
    }
  }

  Widget _buildFormFields() {
    switch (widget.type) {
      case 1:
        return Column(
          children: [
            TextFormField(
              controller: purposeController,
              decoration: InputDecoration(
                labelText: 'Purpose',
                icon: const Icon(Icons.description),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date',
                icon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, startDateController),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: 'End Date',
                icon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, endDateController),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 10),
          ],
        );
      case 2:
        return Column(
          children: [
            for (int i = 0; i < vehicleControllers.length; i++) ...[
              Text("Vehicle ${i + 1}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: vehicleControllers[i],
                decoration: InputDecoration(
                  labelText: 'Vehicle',
                  icon: const Icon(Icons.directions_car),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: driverControllers[i],
                decoration: InputDecoration(
                  labelText: 'Driver',
                  icon: const Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: startKmControllers[i],
                decoration: InputDecoration(
                  labelText: 'Starting KM',
                  icon: const Icon(Icons.speed),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: endKmControllers[i],
                decoration: InputDecoration(
                  labelText: 'Ending KM',
                  icon: const Icon(Icons.speed),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      case 3:
        return Column(
          children: [
            for (int i = 0; i < locationControllers.length; i++) ...[
              TextFormField(
                controller: locationControllers[i],
                decoration: InputDecoration(
                  labelText: 'Location ${i + 1}',
                  icon: const Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton(
              onPressed: () {
                setState(() {
                  locationControllers.add(TextEditingController());
                });
              },
              child: Text("Add Location"),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _updateTrip(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {};
      switch (widget.type) {
        case 1:
          updatedData = {
            'purpose': purposeController.text,
            'starting_date': startDateController.text,
            'ending_date': endDateController.text,
          };
          break;
        case 2:
          updatedData = {
            'vehicle_id': vehicleControllers.map((c) => c.text).toList(),
            'driver': driverControllers.map((c) => c.text).toList(),
            'starting_km': startKmControllers.map((c) => c.text).toList(),
            'ending_km': endKmControllers.map((c) => c.text).toList(),
          };
          break;
        case 3:
          updatedData = {
            'route': locationControllers.map((c) => c.text).toList(),
          };
          break;
      }

      Provider.of<TripProvider>(context, listen: false).updateTripData(
        widget.type,
        widget.tripId,
        updatedData,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    purposeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    for (var controller in vehicleControllers) {
      controller.dispose();
    }
    for (var controller in driverControllers) {
      controller.dispose();
    }
    for (var controller in startKmControllers) {
      controller.dispose();
    }
    for (var controller in endKmControllers) {
      controller.dispose();
    }
    for (var controller in locationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
