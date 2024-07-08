import 'package:flutter/material.dart';
import 'package:insthelper/components/user_list_vehicle_widget.dart';
import 'package:insthelper/provider/homescreen_provider.dart';
import 'package:provider/provider.dart';

class VechicleUserListScreen extends StatefulWidget {
  const VechicleUserListScreen({super.key});

  @override
  State<VechicleUserListScreen> createState() => _VechicleUserListScreen();
}

class _VechicleUserListScreen extends State<VechicleUserListScreen> {
  var deviceSearch = '';

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushNamed(context, '/alert');
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
          UserListVehicleWidget(isHomePage: false, isSearch: deviceSearch)
        ],
      ),
    );
  }
}
