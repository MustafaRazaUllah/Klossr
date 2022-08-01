import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Screens/BottomNav.dart';
import 'package:http/http.dart' as http;
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Validator/Validator.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:toast/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _switchValue = false;
  final validator = Validator();
  bool? _passwordVisible;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token;
  getFCMToken() async {
    token = await _firebaseMessaging.getToken();
    print("toto $token");
  }

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    getFCMToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              "assets/images/black-logo.png",
              height: 150.0,
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: !_passwordVisible!,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible!;
                            });
                          },
                          icon: Icon(_passwordVisible!
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: hexToColor(appGreenColor),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                'By tapping on Sign up, you acknowledge that you have read and agree to our terms and Conditions Privacy policy.',
                                style: TextStyle(
                                    fontSize: 9, color: Colors.black38)),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              activeColor: hexToColor(appGreenColor),
                              value: _switchValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _switchValue = value;
                                  // print(_switchValue);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 60,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: 70,
                                decoration: _switchValue
                                    ? BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      )
                                    : BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                child: Icon(Icons.east,
                                    color: Colors.white, size: 40),
                              ),
                              onTap: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (_) => AlertDialog(
                                //             title: Text('Important Note'),
                                //             content: Text(
                                //                 "Your current age is 18, so please update your profile. If that's the case, disregard this message; otherwise, please go to settings click on User Info and update your information. Thank you for signing up with Klosrr. You're closer than you think to making new friends."),
                                //             actions: [
                                //               TextButton(
                                //                 onPressed: () {},
                                //                 child: Text("Cancel"),
                                //               ),
                                //               TextButton(
                                //                 onPressed: () {},
                                //                 child: Text("ok"),
                                //               )
                                //             ]));
                                validationMethod(context);
                              },
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    " Sign in",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  validationMethod(BuildContext context) {
    ToastContext().init(context);
    FocusManager.instance.primaryFocus!.unfocus();
    final _name = _nameController.text;
    final _username = _usernameController.text;
    final _email = _emailController.text;
    final _password = _passwordController.text;

    if (validator.isNameTrue(_name)) {
      if (validator.isNameTrue(_username)) {
        if (validator.isEmailTrue(_email)) {
          if (validator.isPasswordTrue(_password)) {
            if (_switchValue) {
              signUpMethod(context, _name, _username, _email, _password);
            } else {
              Toast.show("Please agree terms and conditions",
                  textStyle: TextStyle(),
                  duration: Toast.lengthLong,
                  gravity: Toast.center);
            }
          } else {
            Toast.show("Password length must be greater than 7 character!",
                textStyle: TextStyle(),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          }
        } else {
          Toast.show("Email is not valid!",
              textStyle: TextStyle(),
              duration: Toast.lengthLong,
              gravity: Toast.center);
        }
      } else {
        Toast.show("Username length must be greater than 2 character!",
            textStyle: TextStyle(),
            duration: Toast.lengthLong,
            gravity: Toast.center);
      }
    } else {
      Toast.show("Name length must be greater than 2 character!",
          textStyle: TextStyle(),
          duration: Toast.lengthLong,
          gravity: Toast.center);
    }
  }

  signUpMethod(BuildContext context, String name, String username, String email,
      String password) async{
    UserUseCase userUseCase = new UserUseCase();
    var deviceID = await PlatformDeviceId.getDeviceId;
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.signUp(name, username, email, password, token ?? "", deviceID ?? "").then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // Toast.show("User register successfully!", context,
            //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            var token = value.data!.token;
            var id = value.data!.user.id;
            var name = value.data!.user.name;
            var username = value.data!.user.username;
            var email = value.data!.user.email;
            var age = value.data!.user.user_info.age;
            var ghost_mode = value.data!.user.user_info.ghost_mode;
            var about_me = value.data!.user.user_info.about_me;
            var gender = value.data!.user.user_info.gender;
            var latitude = value.data!.user.latitude;
            var longitude = value.data!.user.longitude;
            var image = value.data!.user.profile_image;

            SessionManager().setUserInfo(token, name, username, email, age,
                ghost_mode, about_me, latitude, longitude, password, image);

            SessionManager().setUserId(id.toString());

            FirebaseFirestore.instance
                .collection('users')
                .doc(id.toString())
                .set({
              'name': name,
              'image': image,
              'id': id.toString(),
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null
            });
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                        title: Text('Important Note'),
                        content: Text(
                            "Your current age is 18, so please update your profile. If that's the case, disregard this message; otherwise, please go to settings click on User Info and update your information. Thank you for signing up with Klosrr. You're closer than you think to making new friends."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              moveToHomeScreen();
                            },
                            child: Text("ok"),
                          )
                        ]));
          } else if (value.statusCode == 422) {
            Toast.show("Username or Email is already taken.",
                textStyle: TextStyle(),
                duration: Toast.lengthLong,
                gravity: Toast.center);
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

  moveToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BottomNav(0)));
    _sendAndRetrieveMessage(
        "Your current age is 18, so please update your profile. If that’s the case, disregard this message; otherwise, please go to settings click on User Info and update your information. Thank you for signing up with Klosrr. You’re closer than you think to making new friends.",
        token);
  }

  Future<void> _sendAndRetrieveMessage(String message, String tokin) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."

    final yourServerKey =
        "AAAA8-vbQ9k:APA91bECW4-SOdJhxB-i-hXN0R-JRbkuH06zN_RjC6Ws1vLYDkhroNR4674GWMhkOvfPYVrf2Org-xVsX-qCOeknZGmFwFvI1GhSDWcsrBU_nNwI9uAMsJSOOn74jgwmKQqaGJMSkGkX";
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$yourServerKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': 'Alert',
            // 'image':
            // 'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.
          // 'registration_ids': ["Your_FCM_Token_One", "Your_FCM_Token_Two"],
          'to': tokin
        },
      ),
    );
  }
}
