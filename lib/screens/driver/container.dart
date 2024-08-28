import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/driver/home_screen.dart';
import 'package:insthelper/screens/driver/profile_view.dart';
import 'package:insthelper/screens/driver/trip_page.dart';
import 'package:insthelper/screens/driver/vechicle_list.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DriverContainerScreen extends StatefulWidget {
  const DriverContainerScreen({super.key});

  @override
  State<DriverContainerScreen> createState() => _DriverContainerScreenState();
}

class _DriverContainerScreenState extends State<DriverContainerScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    DriverHomeScreen(),
    VechicleListScreen(),
    TripPage(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    Provider.of<VehicleProvider>(context, listen: false).fetchAllVehicleData();
    Provider.of<VehicleProvider>(context, listen: false).fetchModels();
    Provider.of<VehicleProvider>(context, listen: false).fetchFuelType();
    Provider.of<VehicleProvider>(context, listen: false).fetchDrivers();
    Provider.of<VehicleProvider>(context, listen: false).fetchLocation();
    Provider.of<TripProvider>(context, listen: false).fetchTrip();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final theme = Theme.of(context);

    print("Admin container");
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: _widgetOptions
            .elementAt(context.watch<HomescreenProvider>().selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 8 / textScaleFactor,
            ),
            child: GNav(
              rippleColor: theme.colorScheme.primary.withOpacity(0.2),
              hoverColor: theme.colorScheme.primary.withOpacity(0.1),
              gap: 8 / textScaleFactor,
              activeColor: theme.colorScheme.onPrimary,
              iconSize: 24 / textScaleFactor,
              padding: EdgeInsets.symmetric(
                horizontal: 20 / textScaleFactor,
                vertical: 12 / textScaleFactor,
              ),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: theme.colorScheme.tertiary,
              backgroundColor: theme.colorScheme.primaryContainer,
              tabs: [
                _buildGButton(Icons.home, 'Home', textScaleFactor, theme),
                _buildGButton(Icons.list_alt_outlined, 'Vehicle List',
                    textScaleFactor, theme),
                _buildGButton(
                    Icons.trip_origin, 'Trips', textScaleFactor, theme),
                _buildGButton(
                    LineIcons.user, 'Profile', textScaleFactor, theme),
              ],
              selectedIndex: context.watch<HomescreenProvider>().selectedIndex,
              onTabChange: (index) {
                setState(() {
                  context
                      .read<HomescreenProvider>()
                      .updateMyVariable(newValue: index);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  GButton _buildGButton(
      IconData icon, String text, double textScaleFactor, ThemeData theme) {
    return GButton(
      icon: icon,
      text: text,
      iconActiveColor: theme.colorScheme.inversePrimary,
      textStyle: TextStyle(
        fontSize: 14 / textScaleFactor,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.inversePrimary,
      ),
    );
  }
}
