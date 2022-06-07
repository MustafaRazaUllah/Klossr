import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:klossr/Screens/LoginScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';

import 'BottomNav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // // var token;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) => {iOS_Permission()});
    // Future.delayed(Duration.zero).then((value) => { getFCMToken()});

    Future.delayed(Duration(seconds: 3)).then((value) => {isSessionExit()});
  }

  void iOS_Permission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }
  // getFCMToken() async {
  //   token = await _firebaseMessaging.getToken();
  //   print("toto $token");
  // }

  isSessionExit() async {
    var isSession = await SessionManager().getUserToken();
    if (isSession != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNav(0)));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colsyors.green,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Container(
              // color: Colors.red,
              height: 200.0,
              alignment: Alignment.center,
              child: Image(image: AssetImage('assets/images/splash-icon.png')),
            ),
          ],
        ),
      ),
    );
  }
}
