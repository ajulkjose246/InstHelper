// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:AjceTrips/components/form_input_field.dart';
import 'package:AjceTrips/screens/authentication/auth_services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart' show MediaQuery;

class FixedSizeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  const FixedSizeText(this.text,
      {Key? key, required this.style, this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

class FixedSizeLayout extends StatelessWidget {
  final Widget child;

  const FixedSizeLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaleFactor: 1.0,
        devicePixelRatio: 1.0,
        platformBrightness: mediaQuery.platformBrightness,
      ),
      child: child,
    );
  }
}

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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final textScaleFactor = mediaQuery.textScaleFactor;

    // Adjust base font size based on screen width
    double baseFontSize = screenWidth < 360 ? 16 : 18;

    // Apply text scale factor and limit maximum size
    double titleFontSize = (baseFontSize / textScaleFactor).clamp(14.0, 22.0);
    return FixedSizeLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FixedSizeText(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lufga',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: FixedSizeText(
                          "Login Back into your account",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Switzer',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 450,
                          maxHeight: constraints.maxHeight * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                FixedSizeText(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lufga',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
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
                                  fontSize:
                                      titleFontSize * 0.8, // Add this line
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
                                  fontSize:
                                      titleFontSize * 0.8, // Add this line
                                ),
                                const SizedBox(
                                  height: 20,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                    ),
                                    child: FixedSizeText(
                                      "Login",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontFamily: 'Lufga',
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FixedSizeText(
                              "OR",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontFamily: 'Switzer',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  AuthService().signInWithGoogle(context),
                              icon: Icon(LineIcons.googleLogo,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              label: FixedSizeText(
                                "Sign in with Google",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontFamily: 'Lufga',
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
