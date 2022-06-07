import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/BottomNav.dart';
import 'package:klossr/Screens/UserChatScreen.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
// import 'package:toast/toast.dart';

class FriendRequestScreen extends StatefulWidget {
  StreamController? controller;

  FriendRequestScreen({Key? key, this.controller}) : super(key: key);
  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  List<UserModel> allUsers = [];

  @override
  void initState() {
    showrequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allUsers.length == 0
          ? Center(
              child: Text(
                "No Any Friend Request found!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        foregroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(
                                            // 'https://cdn.pixabay.com/photo/2018/01/21/14/16/woman-3096664__340.jpg'
                                            allUsers[index].profile_image),
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(allUsers[index].name),
                                    ]),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      requestAccept(
                                          allUsers[index].id.toString(), index);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      // color: Colors.red,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Text('Accept',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  GestureDetector(
                                    onTap: () {
                                      requestReject(
                                          allUsers[index].id.toString(), index);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      // color: Colors.red,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text('Decline',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  showrequest() {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.showRequest().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // print("This is the data $totalRequest");
            setState(() {
              allUsers = value.data!.data;
              totalRequest = allUsers.length;
              widget.controller?.sink.add(totalRequest);
              // totalRequest = allUsers.length + 1;
              // print("this is all users record $allUsers");
            });
            // Navigator.pop(context);
          } else if (value.statusCode == 422) {
            Fluttertoast.showToast(
                msg: "Request already sent",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
            // Toast.show(
            //     textStyle: context,
            //     duration: Toast.lengthLong,
            //     gravity: Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  requestAccept(String user_id, int index) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.requestAccept(user_id).then((value) {
          Fluttertoast.showToast(
              msg: "Request accept successfully!",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 12.0);
          hideEasyLoading();
          if (value.statusCode == 200) {
            Fluttertoast.showToast(
                msg: "Request accept successfully!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);

            setState(() {
              allUsers.removeAt(index);
            });

            totalRequest = allUsers.length;
            widget.controller?.sink.add(totalRequest);

            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => BottomNav(1)));
          } else if (value.statusCode == 404) {
            Fluttertoast.showToast(
                msg: "Request already accepted",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  requestReject(String user_id, int index) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.requestReject(user_id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the user id $user_id");
            Fluttertoast.showToast(
                msg: "Request decline successfully!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);

            setState(() {
              allUsers.removeAt(index);
            });

            totalRequest = allUsers.length;
            widget.controller?.sink.add(totalRequest);

            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => BottomNav(1)));

          } else if (value.statusCode == 404) {
            Fluttertoast.showToast(
                msg: "Request already declined",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
