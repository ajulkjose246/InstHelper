import 'package:flutter/material.dart';
import 'package:insthelper/components/driver_list_vehicle_widget.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
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
    print("Admin Vehicle List");
    return Container(
      color: const Color.fromRGBO(236, 240, 245, 1),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) {
                        setState(() {
                          deviceSearch = val;
                        });
                      },
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context
                        .read<HomescreenProvider>()
                        .updateMyVariable(newValue: 4);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/img/demo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/userAlert');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          ListDriverVehicleWidget(isHomePage: false, isSearch: deviceSearch)
        ],
      ),
    );
  }
}
