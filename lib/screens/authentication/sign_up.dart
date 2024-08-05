// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:insthelper/components/form_input_field.dart';
import 'package:insthelper/screens/authentication/auth_services.dart';
import 'package:line_icons/line_icons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 245, 1),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lufga',
                        color: Color.fromRGBO(139, 91, 159, 1)),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Signup into your account",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Switzer',
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lufga',
                              color: Color.fromRGBO(139, 91, 159, 1)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInputField(
                          textcontroller: usernameController,
                          label: '',
                          validator: true,
                          icon: const Icon(Icons.person),
                          regex: RegExp(''),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInputField(
                          textcontroller: usernameController,
                          label: '',
                          validator: true,
                          icon: const Icon(Icons.person),
                          regex: RegExp(''),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInputField(
                          textcontroller: usernameController,
                          label: '',
                          validator: true,
                          icon: const Icon(Icons.person),
                          regex: RegExp(''),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/admin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(139, 91, 159, 1),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lufga',
                                  fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 19, fontFamily: 'Lufga'),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Lufga',
                            color: Color.fromRGBO(139, 91, 159, 1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(LineIcons.googleLogo),
                        onPressed: () => AuthService().signInWithGoogle(),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(LineIcons.github),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(LineIcons.facebook),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
