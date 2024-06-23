import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _databaseReference =
      FirebaseDatabase.instance.ref("Vehicle-Management");

  Future<String> getModelImage(String modelName) async {
    try {
      final snapshot = await _databaseReference
          .child('Models')
          .child(modelName)
          .child('image')
          .get();
      return snapshot.value.toString();
    } catch (e) {
      print('Error fetching model image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      width: 300,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
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
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 300,
                      height: 150,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                Icon(Icons.arrow_circle_right_outlined),
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
                                  "Validity(NT)",
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
                    Container(
                      width: 300,
                      height: 150,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
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
                                Icon(Icons.arrow_circle_right_outlined),
                              ],
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
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Vehicle List",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ),
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
                        crossAxisCount: 2,
                      ),
                      itemCount: (items.length > 5) ? 6 : items.length,
                      itemBuilder: (context, index) {
                        var vehicle = items[index];
                        return FutureBuilder(
                          future: getModelImage(vehicle['Vehicle Type']),
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
                                    height: 170,
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
                                    height: 170,
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
                              print(
                                  'Fetched Image URL: $imageData'); // Debugging output
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/view');
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vehicle['Registration Number']
                                                .toString()
                                                .toUpperCase()
                                                .replaceAll('_', ' '),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19),
                                          ),
                                          Text(
                                            vehicle['Model'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Expanded(
                                            child: imageData.isNotEmpty
                                                ? Image.network(
                                                    imageData,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      print(
                                                          'Error loading image: $error'); // Debugging output
                                                      return const Center(
                                                        child:
                                                            Icon(Icons.error),
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/img/car.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                          ),
                                        ],
                                      ),
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
