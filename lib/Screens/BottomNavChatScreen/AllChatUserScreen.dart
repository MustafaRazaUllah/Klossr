import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/BottomNav.dart';
import 'package:klossr/Screens/BottomNavChatScreen/ReportScreen.dart';
import 'package:klossr/Screens/UserChatScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class AllChatUserScreen extends StatefulWidget {
  final UserModel ? user;
  StreamController ? controller;

  AllChatUserScreen({Key ?key, this.user, this.controller}) : super(key: key);
  @override
  _AllChatUserScreenState createState() => _AllChatUserScreenState();
}

class _AllChatUserScreenState extends State<AllChatUserScreen> {
  List<UserModel> allUsers = [];
  String? currentUserId;
  FirebaseMessaging  firebaseMessaging=FirebaseMessaging.instance ;
  String ? groupChatId;

  @override
  void initState() {
    friends();
    updateData();
  }

  updateData() async {
    currentUserId = await SessionManager().getUserId();

    firebaseMessaging.getToken().then((token) {
      // print('token: $token');
      // print("current user id: $currentUserId");
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      print("Error is $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      body: allUsers.length == 0
          ?SizedBox()
      // Center(
      //         child: Text(
      //           "No Any Friend found!",
      //           style: TextStyle(
      //             fontSize: 18,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //       )
          // : StreamBuilder<QuerySnapshot>(
          //     stream: query.snapshots(),
          //     builder: (context, stream) {
          //   if (stream.connectionState == ConnectionState.waiting) {
          //     return Center(child: CircularProgressIndicator());
          //   }

          //   if (stream.hasError) {
          //     return Center(child: Text(stream.error.toString()));
          //   }

          //   QuerySnapshot querySnapshot = stream.data;

          //   return ListView.builder(
          //     itemCount: querySnapshot.size,
          //     itemBuilder: (context, index) {
          //       return _buildChatView(index, querySnapshot);
          //     },
          //   );
          // },
          //   ));
          : ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, i) {
                return _buildChatView(i);
              }),
    );
  }

  _buildChatView(int index) {
    return Column(
      children: <Widget>[
        new Divider(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserChatScreen(
                          peerId: allUsers[index].id.toString(),
                          peerAvatar: allUsers[index].profile_image,
                          peerName: allUsers[index].name,
                        )));
          },
          onLongPress: () {
            showGeneralDialog(
              barrierLabel: "Label",
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.5),
              transitionDuration: Duration(milliseconds: 200),
              context: context,
              pageBuilder: (context, anim1, anim2) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SizedBox.expand(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                unFriend(allUsers[index].id.toString(), index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text('Unfriend')),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteChat(allUsers[index].id.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text('Delete Chat')),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text('Report')),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportScreen(
                                            allUsers[index].id.toString())));
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text('Block')),
                                ),
                              ),
                              onTap: () {
                                block(
                                  allUsers[index].id.toString(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
              transitionBuilder: (context, anim1, anim2, child) {
                return SlideTransition(
                  position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                      .animate(anim1),
                  child: child,
                );
              },
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: new ListTile(
              leading: new CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey,
                backgroundImage:
                    new NetworkImage(allUsers[index].profile_image),
              ),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    allUsers[index].name, // querySnapshot.docs[index]["id"],
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Container(
                  //   height: 20.0,
                  //   width: 20.0,
                  //   decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Center(
                  //     child: Text(
                  //       "2",
                  //       style: TextStyle(color: Colors.white, fontSize: 14.0),
                  //     ),
                  //   ),
                  // )
                  // new Text(
                  //   dummyData[i].time,
                  //   style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                  // ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  friends() {
    ToastContext().init(context);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.friends().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            setState(() {
              allUsers = value.data!.data;
              widget.controller?.sink.add(allUsers.length);
            });
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            Toast.show("Something went wrong!", textStyle:TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  unFriend(String id, int index) {
    ToastContext().init(context);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.unFriend(id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the id $id");
            Toast.show("Unfriend successfully!", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNav(1)));
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            Toast.show("Something went wrong!", textStyle:TextStyle(),
                duration:Toast.lengthLong, gravity: Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  deleteChat(String peerId) async {
    ToastContext().init(context);
    var fetchUserId = await SessionManager().getUserId();
    var id = fetchUserId.toString();

    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    print("groupChatId $groupChatId");
    Navigator.pop(context);

    var collection = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId!);
    var snapshots = await collection.get();
    if (snapshots.docs.length > 0) {
      EasyLoading.show();
      for (int i = 0; i < snapshots.docs.length; i++) {
        var doc = snapshots.docs[i];
        await doc.reference.delete();
        if (i == snapshots.docs.length - 1) {
          EasyLoading.dismiss();
          Toast.show("Chat deleted successfully!", textStyle: TextStyle(),
              duration: Toast.lengthLong, gravity: Toast.bottom);
        }
      }
    } else {
      print("no any message found!");
    }
  }

// >>>>>>> 20432d7b0e8301db655d043bc1790e1a9b58909e
  block(String block_user) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.block(block_user).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // print("this is the id $id");
            Toast.show("Blocked", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNav(1)));
          } else if (value.statusCode == 422) {
            Toast.show("Already Blocked", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            Toast.show("Something went wrong!", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity:Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
