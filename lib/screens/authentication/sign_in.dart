// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/screens/authentication/auth_services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthService().signInWithEmailAndPassword(
        context,
        usernameController.text,
        passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lufga',
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login Back into your account",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Switzer',
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 450,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
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
                        Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lufga',
                              color: Theme.of(context).colorScheme.primary),
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
                          textcontroller: passwordController,
                          label: '',
                          validator: true,
                          icon: const Icon(Icons.lock),
                          regex: RegExp(''),
                          regexlabel: '',
                          numberkeyboard: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password ? ",
                            style: TextStyle(fontSize: 15, fontFamily: 'Lufga'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signInWithEmailAndPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                      "Dont have an account yet? ",
                      style: TextStyle(fontSize: 19, fontFamily: 'Lufga'),
                    ),
                    GestureDetector(
                      // onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        " Join Now",
                        style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Lufga',
                            color: Theme.of(context).colorScheme.primary),
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
                    _buildSocialButton(LineIcons.googleLogo,
                        () => AuthService().signInWithGoogle(context)),
                    _buildSocialButton(LineIcons.github, () {}),
                    _buildSocialButton(LineIcons.facebook, () {}),
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

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
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
        icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        onPressed: onPressed,
      ),
    );
  }
}
