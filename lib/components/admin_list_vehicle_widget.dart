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
  @override
  Widget build(BuildContext context) {
    Provider.of<VehicleProvider>(context, listen: false).fetchAllVehicleData();
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
              padding: const EdgeInsets.all(10),
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
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle['registration_number']
                              .toString()
                              .toUpperCase()
                              .replaceAll('_', ' '),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Text(
                          vehicle['model'],
                          style: const TextStyle(fontSize: 15),
                        ),
                        Expanded(
                          child: vehicle['vehicle_type_image'].isNotEmpty
                              ? Image.network(
                                  vehicle['vehicle_type_image'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        'Error loading image: $error'); // Debugging output
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 240, 245, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.health_and_safety,
                                  color: insuranceIcon,
                                ),
                                Icon(
                                  Icons.construction,
                                  color: fitnessIcon,
                                ),
                                Icon(
                                  Icons.air,
                                  color: pollutionIcon,
                                ),
                              ],
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
