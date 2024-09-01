// ignore_for_file: avoid_print

import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RequestPermmision {
  bool _isRequesting = false;

  Future<void> requestPermission() async {
    if (_isRequesting) {
      print("A permission request is already in progress");
      return;
    }

    _isRequesting = true;

    try {
      var notificationStatus = await Permission.notification.status;

      if (notificationStatus.isGranted) {
        print("Notification permission already granted");
      } else {
        // Request permission
        var result = await Permission.notification.request();
        if (result.isGranted) {
          print("Notification permission granted");
        } else {
          print("Notification permission denied");
        }
      }
    } finally {
      _isRequesting = false;
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }
}
