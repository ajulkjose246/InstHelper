import 'package:flutter/material.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/provider/trip_provider.dart';
import 'package:intl/intl.dart';

class TripUpdateMessage extends StatefulWidget {
  const TripUpdateMessage({
    super.key,
    required this.type,
    required this.formattedRegNumber,
    required this.vehicleData,
  });

  final int type;
  final String formattedRegNumber;
  final Map<String, dynamic>? vehicleData;

  @override
  State<TripUpdateMessage> createState() => _TripUpdateMessageState();
}

class _TripUpdateMessageState extends State<TripUpdateMessage> {
  final _formKey = GlobalKey<FormState>();

  final purposeController = TextEditingController();
  final startingTimeController = TextEditingController();
  DateTime? startingDate;

  @override
  void initState() {
    super.initState();
    purposeController.text = widget.vehicleData!['purpose'];
    startingTimeController.text = widget.vehicleData!['starting_time'];
    startingDate = DateTime.parse(widget.vehicleData!['starting_date']);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startingDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startingDate) {
      setState(() {
        startingDate = picked;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update Trip Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FormInputField(
                textcontroller: purposeController,
                label: 'Purpose',
                validator: true,
                icon: const Icon(Icons.description),
                regex: RegExp(r'^.+$'),
                regexlabel: 'Purpose cannot be empty',
                numberkeyboard: false,
              ),
              const SizedBox(height: 10),
              FormInputField(
                textcontroller: startingTimeController,
                label: 'Starting Time',
                validator: true,
                icon: const Icon(Icons.access_time),
                regex: RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$'),
                regexlabel: 'Enter a valid time (HH:MM)',
                numberkeyboard: true,
              ),
              const SizedBox(height: 10),
              _buildDateField(context, "Starting Date", startingDate),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          startingDate != null) {
                        // TripProvider().updateTripData(
                        //   widget.vehicleData!['id'],
                        //   purposeController.text,
                        //   startingTimeController.text,
                        //   startingDate!.toIso8601String(),
                        // );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label, DateTime? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Icon(Icons.calendar_month),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  date != null ? formatDate(date) : label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
