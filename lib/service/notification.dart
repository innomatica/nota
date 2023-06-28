import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/timezone.dart';

import '../shared/constants.dart';

const channelId = 'com.innomatic.regioapp.notification';
const channelName = 'Regio Notification';
const tickerText = 'Regio Ticker';
const notificationId = 0;

//
// Notification Tap Handler
//
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationService {
  NotificationService._private();
  static final NotificationService _instance = NotificationService._private();
  factory NotificationService() {
    return _instance;
  }
  final _notification = FlutterLocalNotificationsPlugin();

  Future initialize() async {
    // initialize timezone database
    tz.initializeTimeZones();
    // get current timezone name
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    // set my location in the database
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // ...
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  //
  // This will ask permission only on API 33 (android 13) or higher
  // Otherwise, let the user do the job manually
  //
  Future<bool?> checkPermission() async {
    return await _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
  }

  Future cancelNotification(int id) async {
    debugPrint('notification $id cancelled');
    await _notification.cancel(id);
  }

  Future cancelAllNotifications() async {
    final requests = await _notification.pendingNotificationRequests();
    for (final request in requests) {
      await _notification.cancel(request.id);
    }
  }

  // immediately show notification
  Future showNotification(
      {String? title, String? body, String? payload}) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: tickerText,
      ),
    );
    await _notification.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future scheduleNotification({
    required int id,
    required DateTime when,
    String? title,
    String? body,
    String? payload,
    DateTimeComponents? match,
  }) async {
    await _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          appId,
          appName,
          channelDescription: appDescription,
          enableVibration: true,
          enableLights: true,
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: match,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
