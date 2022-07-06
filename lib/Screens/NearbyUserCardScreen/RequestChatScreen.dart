import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as https;

import "package:klossr/extension/string_extension.dart";

class RequestChatScreen extends StatefulWidget {
  final UserModel user;

  String userId;
  String token;
  RequestChatScreen(this.user, this.userId, {this.token = ""});

  @override
  _RequestChatScreenState createState() => _RequestChatScreenState();
}

class _RequestChatScreenState extends State<RequestChatScreen> {
  // double mileDistance;
  var userId;
  var token;
  bool requested = false;
  bool isLoading = false;
  @override
  void initState() {
    // mileDistance = widget.user.distance * 0.000621371;
    super.initState();

    checkAlreadyRequest();
  }

  checkAlreadyRequest() async {
    try {
      setState(() {
        isLoading = true;
      });

      ToastContext().init(context);
      print('statusCode');
      print(widget.userId);
      print(widget.token);
      print(widget.user.id);

      var response = await https.post(
        Uri.parse("https://api.klosrr.com/api/v1/check-friend"),
        body: {
          "user_id": widget.userId.toString(),
          "friend_id": widget.user.id.toString()
        },
        headers: {
          "Authorization": "Bearer ${widget.token.toString()}",
        },
      );
      print('statusCode1111');
      print(jsonDecode(response.body));
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print(jsonDecode(response.body));
        setState(() {
          requested = jsonDecode(response.body)["is_request"];
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show("Something went wrong!",
            textStyle: TextStyle(),
            duration: Toast.lengthLong,
            gravity: Toast.center);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(['API exception get', e.toString()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8), //Colors.pink,
                    ),
                    child: Image.network(
                      //'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHBlcnNvbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      widget.user.profile_image,
                      fit: BoxFit.fill,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Image.network(
                    //     //'https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHBlcnNvbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                    //     widget.user.profile_image,
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      alignment: Alignment.topLeft,
                      // height: 40,
                      // width: 40,

                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              size: 25,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  // Positioned(child: child),
                  Positioned(
                    bottom: 20,
                    left: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        // height: 40,
                        // width: 40,

                        // decoration: BoxDecoration(
                        //     color: Colors.black.withOpacity(0.4),
                        //     shape: BoxShape.circle),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.user.name.capitalize()}, ${widget.user.user_info.age.toString()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              widget.user
                                  .distance, //mileDistance.toStringAsFixed(2) + ' mi',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About me',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.user.user_info.about_me,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          if (requested == false) {
                            requestToChat(widget.user.id.toString());
                            print(
                                "this is user id from send request ${widget.user.id}");
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(22)),
                            child: Center(
                              child: requested == false
                                  ? Text('Request to Chat',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0))
                                  : Text('Requested to Chat',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0)),
                            )),
                      ),
                    ),
                  ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Container(
            //     margin: EdgeInsets.only(top: 110.0),
            //     height: MediaQuery.of(context).size.height * 0.09,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(33.0),
            //         color: Colors.black),
            //     child: Center(
            //       child: Text('Request to chat',
            //           style: TextStyle(color: Colors.white, fontSize: 19)),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  requestToChat(String id) {
    ToastContext().init(context);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.sendRequest(id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            Toast.show("request sent successfully!",
                textStyle: TextStyle(),
                duration: Toast.lengthLong,
                gravity: Toast.center);
            Navigator.pop(context, true);
          } else if (value.statusCode == 400) {
            Toast.show("Request already sent",
                textStyle: TextStyle(),
                duration: Toast.lengthLong,
                gravity: Toast.center);
            Navigator.pop(context, true);
          } else {
            Toast.show("Something went wrong!",
                textStyle: TextStyle(),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
