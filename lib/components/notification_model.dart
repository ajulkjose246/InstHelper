import 'package:workmanager/workmanager.dart';

class NotificationModel {
  Future<void> scheduleExpiryNotification(
      String title, String body, DateTime scheduledDate) async {
    final now = DateTime.now();
    final delay = scheduledDate.difference(now);

    Workmanager().registerOneOffTask(
      'expiry_notification_task',
      'notify_expiry',
      initialDelay: delay,
      inputData: {
        'title': title,
        'body': body,
      },
    );
  }
}
