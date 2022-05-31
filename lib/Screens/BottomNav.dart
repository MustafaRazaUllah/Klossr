import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:klossr/Screens/BottomNav/ChatScreen.dart';
import 'package:klossr/Screens/BottomNav/FindUserScreen.dart';
import 'package:klossr/Screens/BottomNav/SettingScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/Utilities/notification_check.dart';

import '../Constant/constants.dart';
import 'BottomNav/HomeScreen.dart';

class BottomNav extends StatefulWidget {
  final int index;
  BottomNav(this.index);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  var controller = Get.put(NotificationViewModel());

  final tab = [
    HomeScreen(),
    ChatScreen(),
    FindUserScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons-klosrr/compass.svg",
                    width: 23,
                    height: 23,
                    color: _currentIndex == 0
                        ? hexToColor(appGreenColor)
                        : Colors.black,
                  ), //Icon(CupertinoIcons.home),
                  label: "",
                  // _currentIndex == 1
                  //     ? new Image.asset('assets/images/dumbell_icon_active.png',
                  //         height: 30.0)
                  //     : new Image.asset('assets/images/dumbell_icon.png',
                  //         height: 25.0),
                  // title: new Text(''),
                ),
                controller.isValid.value
                    ? BottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/icons-klosrr/chat.svg",
                              width: 23,
                              height: 23,
                              color: _currentIndex == 1
                                  ? hexToColor(appGreenColor)
                                  : Colors.black,
                            ),
                            Positioned(
                              right: 0,
                              top: 4,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        label: "",
                      )
                    : BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons-klosrr/chat.svg",
                          width: 23,
                          height: 23,
                          color: _currentIndex == 1
                              ? hexToColor(appGreenColor)
                              : Colors.black,
                        ),
                        label: "",
                      ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons-klosrr/map.svg",
                    width: 23,
                    height: 23,
                    color: _currentIndex == 2
                        ? hexToColor(appGreenColor)
                        : Colors.black,
                  ),
                  //Icon(CupertinoIcons.location),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.profile_circled,
                    color: _currentIndex == 3
                        ? hexToColor(appGreenColor)
                        : Colors.black,
                  ),
                  label: "",
                ),
              ],
              onTap: (index) {
                if (index == 1) {
                  setState(() {
                    SessionManager().messageClear();
                    controller.check();
                    _currentIndex = index;
                  });
                }
                setState(() {
                  _currentIndex = index;
                });
              },
            )),
        body: tab[_currentIndex]);
  }

  _showExitDialogue(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          final screenSize = MediaQuery.of(context).size;
          return AlertDialog(
            insetPadding: EdgeInsets.all(30.0),
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 150.0,
              width: screenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      height: 1.0,
                    ),
                    Text(
                      "Do you want to exit from app?",
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.8), fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Container(
                            height: 45.0,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xffff8218),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            height: 45.0,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xffff8218),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
