import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/Utilities/local_notification.dart';
import 'package:klossr/Utilities/notification_check.dart';
import 'package:klossr/screens/SplashScreen.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:toast/toast.dart';

var controller = Get.put(NotificationViewModel());
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("message recieved");
  print(message);

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  LocalNotifications().init();
  LocalNotifications().notification(
      '${message.notification!.title}', '${message.notification!.body}');

  if (message.notification!.title == "Message") {
    await SessionManager().setUserYu('hg');
    controller.check();
  } else {
    controller.check();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Firebase.initializeApp();
  LocalNotifications().init();

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;
      print("FCM Token====>");
      print(token);
      SessionManager().setFirebaseToken(token);
      // await DatabaseHandler().setFCMToken(token!);
    });
  var deviceID = await PlatformDeviceId.getDeviceId;
  print("deviceID=>> ");
  print(  deviceID.toString());
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage event) async {
      print("recieved");
      print(event.notification!.title);

      LocalNotifications().notification(
          '${event.notification!.title}', '${event.notification!.body}');
      if (event.notification!.title == "Message") {
        await SessionManager().setUserYu('hg');
        controller.check();
      } else {
        controller.check();
      }
    },
  );
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    print("app is open  recieved");
    print(message.data);

    LocalNotifications().notification(
        '${message.notification!.title}', '${message.notification!.body}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = hexToColor(appGreenColor)
    ..backgroundColor = Colors.transparent
    ..indicatorColor = hexToColor(appGreenColor)
    ..textColor = hexToColor(appGreenColor)
    ..maskColor = hexToColor(appGreenColor)
    ..userInteractions = false
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: hexToColor(appGreenColor)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}




// export PATH="$PATH:/Users/macbookpro/Documents/flutter/bin"
// export PATH="$PATH:/Users/macbookpro/.pub-cache/bin"
// export PATH="$PATH:/usr/lib/dart/bin"

