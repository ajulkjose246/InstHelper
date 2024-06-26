import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:insthelper/functions/home_screen_function.dart';
import 'package:insthelper/screens/user/vehicle_view.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification List",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(139, 91, 159, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(236, 240, 245, 1),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref('Vehicle-Management')
                    .child('Vehicles')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    Map data = snapshot.data!.snapshot.value as Map;
                    List items = [];

                    data.forEach((key, value) {
                      items.add({"key": key, ...value});
                    });

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        // Adjusted to control the height
                        childAspectRatio: 2.5,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var vehicle = items[index];
                        return FutureBuilder(
                          future: HomeScreenFunction()
                              .getModelImage(vehicle['Vehicle Type']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/view');
                                  },
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/view');
                                  },
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              var imageData = snapshot.data as String;
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "KL 71 F 9894",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19),
                                            ),
                                            Spacer(),
                                            Icon(Icons
                                                .arrow_circle_right_outlined),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          "Hyundai Exter",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              "Insurance",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19),
                                            ),
                                            Spacer(),
                                            Text("17-Nov-2024"),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                            "We will notify you 30 days before the any validity expiry")
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }

                  return Center(child: Text('No data available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
