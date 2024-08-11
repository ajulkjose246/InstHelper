// ignore_for_file: avoid_print

import 'package:permission_handler/permission_handler.dart';

class RequestPermmision {
  Future<void> requestPermission() async {
    var notificationStatus = await Permission.notification.status;
    var systemAlertWindowStatus = await Permission.notification.status;
    print("Current notificationStatus: $notificationStatus");
    print("Current systemAlertWindowStatus: $systemAlertWindowStatus");
    // Request setting alaram
    if (systemAlertWindowStatus.isGranted) {
      print("systemAlertWindow permission granted");
    } else if (notificationStatus.isDenied) {
      print("systemAlertWindow permission denied");
      await openAppSettings();
    } else if (notificationStatus.isPermanentlyDenied) {
      print("systemAlertWindow permission permanently denied");
      await openAppSettings();
    }

    if (notificationStatus.isGranted) {
      print("Notification permission granted");
    } else if (notificationStatus.isDenied) {
      print("Notification permission denied");
      await openAppSettings();
    } else if (notificationStatus.isPermanentlyDenied) {
      print("Notification permission permanently denied");
      await openAppSettings();
    }
  }
}
