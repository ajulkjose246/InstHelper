import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key});

  @override
  ProfileUserScreenState createState() => ProfileUserScreenState();
}

class ProfileUserScreenState extends State<ProfileUserScreen> {
  @override
  Widget build(BuildContext context) {
    print("User Profilwe ");
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 245, 1),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/img/demo.jpg'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ajul K Jose",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dark Mode"),
                      Switch(
                          activeColor: Colors.red,
                          value: true,
                          onChanged: (value) {})
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
