// ignore_for_file: avoid_print

import 'package:permission_handler/permission_handler.dart';

class RequestPermmision {
  Future<void> requestPermission() async {
    var notificationStatus = await Permission.notification.status;

    if (notificationStatus.isGranted) {
      print("Notification permission granted");
    } else {
      // Request permission
      var result = await Permission.notification.request();
      if (result.isGranted) {
        print("Notification permission granted");
      } else {
        print("Notification permission denied");
      }
    }
  }
}
