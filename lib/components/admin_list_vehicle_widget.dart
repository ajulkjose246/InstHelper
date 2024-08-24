import 'package:flutter/material.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:insthelper/screens/admin/vehicle_view.dart';

class ListAdminVehicleWidget extends StatefulWidget {
  const ListAdminVehicleWidget({
    super.key,
    required this.isHomePage,
    required this.isSearch,
  });

  final bool isHomePage;
  final String isSearch;

  @override
  _ListAdminVehicleWidgetState createState() => _ListAdminVehicleWidgetState();
}

class _ListAdminVehicleWidgetState extends State<ListAdminVehicleWidget> {
  String _getStatus(Color color) {
    if (color == Colors.green) return 'Good';
    if (color == Colors.amber) return 'Warning';
    return 'Expired';
  }

  String _formatDate(String dateString) {
    final date = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  String _getRemainingDays(String dateString) {
    final date = DateFormat('yyyy-MM-dd').parse(dateString);
    final difference = date.difference(DateTime.now()).inDays;
    return difference > 0 ? difference.toString() : '0';
  }

  Widget _buildStatusRow(String title, String date, Color statusColor) {
    final formattedDate = _formatDate(date);
    final remainingDays = _getRemainingDays(date);
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formattedDate,
                style: TextStyle(
                    fontSize: 13, color: theme.colorScheme.onSurface)),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatus(statusColor),
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'Remaining: $remainingDays days',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<VehicleProvider>(context, listen: false).fetchAllVehicleData();
    final theme = Theme.of(context);
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        List items = vehicleProvider.vehicles.values.toList();
        List filteredItems = items.where((vehicle) {
          return vehicle['registration_number']
                  .toString()
                  .toLowerCase()
                  .replaceAll('_', ' ')
                  .contains(widget.isSearch.toLowerCase()) ||
              vehicle['model']
                  .toString()
                  .toLowerCase()
                  .contains(widget.isSearch.toLowerCase());
        }).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                (MediaQuery.of(context).size.height / 4.5),
          ),
          itemCount: widget.isHomePage
              ? (items.length > 5)
                  ? 6
                  : items.length
              : filteredItems.length,
          itemBuilder: (context, index) {
            var vehicle =
                widget.isHomePage ? items[index] : filteredItems[index];
            Color fitnessIcon;
            Color insuranceIcon;
            Color pollutionIcon;
            if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Fitness_Upto'])
                .isAfter(DateTime.now().add(const Duration(days: 30)))) {
              fitnessIcon = Colors.green;
            } else if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Fitness_Upto'])
                .isAfter(DateTime.now())) {
              fitnessIcon = Colors.amber;
            } else {
              fitnessIcon = Colors.red;
            }
            if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Insurance_Upto'])
                .isAfter(DateTime.now().add(const Duration(days: 30)))) {
              insuranceIcon = Colors.green;
            } else if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Insurance_Upto'])
                .isAfter(DateTime.now())) {
              insuranceIcon = Colors.amber;
            } else {
              insuranceIcon = Colors.red;
            }
            if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Pollution_Upto'])
                .isAfter(DateTime.now().add(const Duration(days: 30)))) {
              pollutionIcon = Colors.green;
            } else if (DateFormat('yyyy-MM-dd')
                .parse(vehicle['Pollution_Upto'])
                .isAfter(DateTime.now())) {
              pollutionIcon = Colors.amber;
            } else {
              pollutionIcon = Colors.red;
            }
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleViewScreen(
                        vehicleRegistrationId: vehicle['id'],
                        vehicleRegistrationNo: vehicle['registration_number'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle['registration_number']
                              .toString()
                              .toUpperCase()
                              .replaceAll('_', ' '),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.onSurface),
                          textScaleFactor: 0.8,
                        ),
                        Text(
                          vehicle['model'],
                          style: TextStyle(
                              fontSize: 13, color: theme.colorScheme.onSurface),
                          textScaleFactor: 0.8,
                        ),
                        Expanded(
                          child: vehicle['vehicle_type_image'].isNotEmpty
                              ? Image.network(
                                  vehicle['vehicle_type_image'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading image: $error');
                                    return Center(
                                      child: Icon(Icons.error,
                                          color: theme.colorScheme.error),
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/img/car.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: theme.colorScheme.surface,
                                  title: Text('Vehicle Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildStatusRow(
                                          'Insurance',
                                          vehicle['Insurance_Upto'],
                                          insuranceIcon),
                                      SizedBox(height: 12),
                                      _buildStatusRow('Fitness',
                                          vehicle['Fitness_Upto'], fitnessIcon),
                                      SizedBox(height: 12),
                                      _buildStatusRow(
                                          'Pollution',
                                          vehicle['Pollution_Upto'],
                                          pollutionIcon),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Close',
                                          style: TextStyle(
                                              color:
                                                  theme.colorScheme.primary)),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.health_and_safety,
                                    color: insuranceIcon,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.construction,
                                    color: fitnessIcon,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.air,
                                    color: pollutionIcon,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
