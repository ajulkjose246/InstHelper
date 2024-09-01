import 'package:flutter/material.dart';
import 'package:AjceTrips/components/admin_list_vehicle_widget.dart';
import 'package:AjceTrips/provider/homescreen_provider.dart';
import 'package:provider/provider.dart';

class VechicleListScreen extends StatefulWidget {
  const VechicleListScreen({super.key});

  @override
  State<VechicleListScreen> createState() => _VechicleListScreenState();
}

class _VechicleListScreenState extends State<VechicleListScreen> {
  var deviceSearch = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: Icon(Icons.search,
                            color: theme.colorScheme.onSurface),
                      ),
                      onChanged: (val) {
                        setState(() {
                          deviceSearch = val;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    context
                        .read<HomescreenProvider>()
                        .updateMyVariable(newValue: 3);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.asset(
                        'assets/img/user.png',
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
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Icon(Icons.notifications,
                          color: theme.colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListAdminVehicleWidget(isHomePage: false, isSearch: deviceSearch)
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required VoidCallback onTap, required Widget child}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      ),
    );
  }
}
