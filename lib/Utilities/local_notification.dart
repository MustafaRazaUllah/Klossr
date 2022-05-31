import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';

class LocalNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    print("you clicked notification");
    // if (await DatabaseHandler().isExists("date")) {
    //   String date = await DatabaseHandler().getDate();
    //   String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //   if (today == date) {
    //     print("payload");
    //     print(payload);
    //     Get.offAll(HomeViewController());
    //   } else {
    //
    //   }
    //
    //   print(date);
    // }
  }

  Future notification(
    String title,
    String message,
  ) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('Channel ID', 'Channel title',
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      iOS: iosNotificationDetails,
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        0, title, message, notificationDetails);
  }

  Future onSelectNotification({String payLoad = ""}) async {
    print("you clicked notification");
    // if (await DatabaseHandler().isExists("date")) {
    //   String date = await DatabaseHandler().getDate();
    //   String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //   if (today == date) {
    //     payLoad=="newMessage"?Get.offAll(InboxViewController()):Get.offAll(HomeViewController());
    //   } else {
    //
    //   }
    //
    //   print(date);
    // }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("title======>>>");
              print(title);
              print(payload);
            },
            child: Text("Okay")),
      ],
    );
  }
}
