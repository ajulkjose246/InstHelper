import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:AjceTrips/provider/theme_provider.dart';
import 'package:provider/provider.dart';
// Add these imports
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? userRole;
  bool _mounted = true;
  // Add these variables
  bool isSystemAuthEnabled = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    // Add this line
    _loadSystemAuthStatus();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _fetchUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists && _mounted) {
        setState(() {
          userRole = userDoc.data()?['role'] ?? 'Unknown';
        });
      }
    }
  }

  // Add these methods
  Future<void> _loadSystemAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (_mounted) {
      setState(() {
        isSystemAuthEnabled = prefs.getBool('systemAuthEnabled') ?? false;
      });
    }
  }

  Future<void> _saveSystemAuthStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('systemAuthEnabled', value);
  }

  Future<void> _toggleSystemAuth(bool value) async {
    if (value) {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason:
              'Please authenticate to enable system authentication',
          options: const AuthenticationOptions(
            biometricOnly: false, // Allow non-biometric options
            stickyAuth: true,
          ),
        );
        if (didAuthenticate) {
          await _saveSystemAuthStatus(true);
          if (_mounted) {
            setState(() {
              isSystemAuthEnabled = true;
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Biometric authentication is not available on this device.')),
        );
      }
    } else {
      await _saveSystemAuthStatus(false);
      if (_mounted) {
        setState(() {
          isSystemAuthEnabled = false;
        });
      }
    }
  }

  Future<void> checkForUpdates() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final versionsRef = FirebaseFirestore.instance.collection('Versions');
      final QuerySnapshot versionsSnapshot = await versionsRef.get();

      String latestVersion = '0.0.0';
      String downloadUrl = '';

      for (var doc in versionsSnapshot.docs) {
        String version = doc.id;
        if (compareVersions(version, latestVersion) > 0) {
          latestVersion = version;
          downloadUrl = doc.get('url') as String;
        }
      }

      if (compareVersions(latestVersion, currentVersion) > 0) {
        showUpdateDialog(latestVersion, downloadUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are using the latest version.')),
        );
      }
    } catch (e) {
      print('Error checking for updates: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check for updates.')),
      );
    }
  }

  int compareVersions(String v1, String v2) {
    var v1Parts = v1.split('.').map(int.parse).toList();
    var v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }

  void showUpdateDialog(String latestVersion, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A new version ($latestVersion) of the app is available.'),
              SizedBox(height: 10),
              Text('Update URL:'),
              Text(downloadUrl, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Copy URL'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: downloadUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('URL copied to clipboard')),
                );
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                try {
                  String cleanUrl =
                      downloadUrl.trim().replaceAll(RegExp(r'^"|"$'), '');
                  final url = Uri.parse(cleanUrl);
                  if (await canLaunchUrl(url)) {
                    bool launched = await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                    if (!launched) {
                      throw 'Could not launch $url';
                    }
                  } else {
                    throw 'Could not launch $url';
                  }
                } catch (e) {
                  print('Error launching URL: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to open update link. URL copied to clipboard instead.')),
                  );
                  Clipboard.setData(ClipboardData(text: downloadUrl));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20 / textScaleFactor),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.inversePrimary,
                        radius: 50 / textScaleFactor,
                        backgroundImage: AssetImage('assets/img/user.png'),
                      ),
                      SizedBox(height: 10 / textScaleFactor),
                      Text(
                        FirebaseAuth.instance.currentUser?.displayName ??
                            FirebaseAuth.instance.currentUser?.email ??
                            "Admin",
                        style: TextStyle(
                          fontSize: 20 / textScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        "${userRole ?? 'Loading...'}",
                        style: TextStyle(
                          fontSize: 14 / textScaleFactor,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(15 / textScaleFactor),
                  padding: EdgeInsets.all(10 / textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 16 / textScaleFactor,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeProvider>().setThemeMode(value);
                        },
                      )
                    ],
                  ),
                ),
                // Add this container for System Authentication toggle
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(15 / textScaleFactor),
                  padding: EdgeInsets.all(10 / textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Enable System Authentication",
                        style: TextStyle(
                          fontSize: 16 / textScaleFactor,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        value: isSystemAuthEnabled,
                        onChanged: _toggleSystemAuth,
                      )
                    ],
                  ),
                ),
                // Updated container for the Check Updates button
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(15 / textScaleFactor),
                  padding: EdgeInsets.all(10 / textScaleFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Check for Updates",
                        style: TextStyle(
                          fontSize: 16 / textScaleFactor,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.system_update,
                            color: theme.colorScheme.primary),
                        onPressed: checkForUpdates,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 16 / textScaleFactor,
              right: 16 / textScaleFactor,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.power_settings_new,
                      color: theme.colorScheme.error),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    final googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
