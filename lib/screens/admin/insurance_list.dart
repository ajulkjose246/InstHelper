import 'package:flutter/material.dart';

class InsuranceList extends StatefulWidget {
  const InsuranceList({super.key});

  @override
  State<InsuranceList> createState() => _InsuranceListState();
}

class _InsuranceListState extends State<InsuranceList> {
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
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
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
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_circle_right_outlined),
                      ],
                    ),
                    Spacer(),
                    const Text(
                      "Hyundai Exter",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
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
          ),
        ],
      ),
    );
  }
}
