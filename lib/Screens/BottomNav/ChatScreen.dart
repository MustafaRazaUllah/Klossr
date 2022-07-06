import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Screens/BottomNavChatScreen/AllChatUserScreen.dart';
import 'package:klossr/Screens/BottomNavChatScreen/FriendRequestScreen.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key ? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TabController ? _controller;

  StreamController<int> _friendsController = StreamController<int>();
  StreamController<int> _requestController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    friends();
    showrequest();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title:
            Text('Chats', style: TextStyle(color: Colors.black, fontSize: 22)),
        actions: [
          // IconButton(
          //     onPressed: () {}, icon: Icon(Icons.search, color: Colors.black)),
        ],
        bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 18.0),
            controller: _controller,
            tabs: [
              Tab(
                icon: StreamBuilder(
                  initialData: totalFriends,
                  stream: _friendsController.stream,
                  builder: (_, snapshot) => BadgeIcon(
                    icon: Text("     "), //Icon(Icons.chat, size: 25),
                    badgeCount: int.parse(snapshot.data!.toString()),
                    badgeColor: Colors.black,
                    showIfZero: true,
                  ),
                ),
                text: "Friends List",
                // totalFriends > 0
                //     ? '$totalFriends Friends List'
                //     : "Friends List",
              ),
              Tab(
                icon: StreamBuilder(
                  initialData: totalRequest,
                  stream: _requestController.stream,
                  builder: (_, snapshot) => BadgeIcon(
                    icon: Text("     "), //Icon(Icons.chat, size: 25),
                    badgeCount:int.parse(snapshot.data!.toString()),
                    badgeColor: Colors.black,
                    showIfZero: true,
                  ),
                ),
                text: "Request",
                // text: totalRequest > 0 ? '$totalRequest Requests' : "Requests",
              )
            ]),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          AllChatUserScreen(
            controller: _friendsController,
          ),
          FriendRequestScreen(
            controller: _requestController,
          )
        ],
      ),
    );
  }

  friends() {
    totalFriends = 0;
    _friendsController.sink.add(totalFriends);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.friends().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            setState(() {
              totalFriends = value.data!.data.length;
              _friendsController.sink.add(totalFriends);
            });
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.center);
          } else {
            Toast.show("Something went wrong!", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.center);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  showrequest() {
    totalRequest = 0;
    _requestController.sink.add(totalRequest);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.showRequest().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // print("This is the data ${value.data.data.length}");
            setState(() {
              totalRequest = value.data!.data.length;
              _requestController.sink.add(totalRequest);
            });
            // Navigator.pop(context);
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.center);
          } else {
            Toast.show("Something went wrong!", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.center);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}

class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {this.icon,
      this.badgeCount = 0,
      this.showIfZero = false,
      this.badgeColor = Colors.red,
      TextStyle ? badgeTextStyle})
      : this.badgeTextStyle = badgeTextStyle ??
            TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold);
  final Widget ? icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[icon!,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
        right: 0,
        top: 0,
        child: new Container(
          // padding: EdgeInsets.all(3),
          decoration: new BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              // textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
