import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:insthelper/provider/trip_provider.dart';
import 'package:insthelper/provider/vehicle_provider.dart';
import 'package:insthelper/screens/admin/home_screen.dart';
import 'package:insthelper/screens/admin/profile_view.dart';
import 'package:insthelper/screens/admin/trip_page.dart';
import 'package:insthelper/screens/admin/vechicle_list.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
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
    print("Admin container");
    return Scaffold(
      backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
      body: SafeArea(
        child: _widgetOptions
            .elementAt(context.watch<HomescreenProvider>().selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(139, 91, 159, 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.grey[100]!,
            backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.list_alt_outlined,
                text: 'Vehicle List',
              ),
              GButton(
                icon: Icons.trip_origin,
                text: 'Trips',
              ),
              // GButton(
              //   icon: LineIcons.tools,
              //   text: 'Service',
              // ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
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
      floatingActionButton:
          context.watch<HomescreenProvider>().selectedIndex == 0
              ? FloatingActionButton.small(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
