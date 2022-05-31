import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Screens/SignupScreen.dart';

import 'package:klossr/Screens/ForgotPassword/VerifyEmailScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Validator/Validator.dart';
import 'package:toast/toast.dart';

import 'BottomNav.dart';

class LoginScreen extends StatefulWidget {

   LoginScreen({Key ? key,}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserUseCase userUseCase = new UserUseCase();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final validator = Validator();

    FirebaseMessaging  _firebaseMessaging=FirebaseMessaging.instance;
  var   token;

  bool ? _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) => {getFCMToken()});
    _passwordVisible = false;
    // userUseCase.signIn("khizaraslam", "1234567y","");
    super.initState();
  }

  getFCMToken() async {
    token = await _firebaseMessaging.getToken();
    print("toto $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
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
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: 'Username', hintText: 'Username'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible!,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible!;
                              });
                            },
                            icon: Icon(
                              _passwordVisible!
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: hexToColor(appGreenColor),
                            )),
                        labelText: 'Password',
                        hintText: 'Password'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    // alignment: Alignment.centerRight,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text('Forgot password?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black54)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyEmailScreen()));
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 60,
                          // color: Colors.red,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    child: Container(
                                      height: 60,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.east,
                                          color: Colors.white, size: 40),
                                    ),
                                    onTap: () {
                                      // moveToHomeScreen();
                                      validationMethod(context);
                                    }),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don\'t have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  validationMethod(BuildContext context) {
    ToastContext().init(context);
    FocusManager.instance.primaryFocus!.unfocus();
    final _username = _usernameController.text;
    final _password = _passwordController.text;

    if (validator.isUsernameTrue(_username)) {
      if (validator.isPasswordTrue(_password)) {
        signInMethod(context, _username, _password);
      } else {

        Toast.show("Password length must be greater than 7 character!", textStyle:  TextStyle(),
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else {
      Toast.show("Username is not valid!", textStyle:  TextStyle(),
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }
  }

  signInMethod(BuildContext context, String username, String password) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) async {
      if (value) {
        showEasyloaging();
         userUseCase.signIn(username.trim(), password,token??"").then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
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

            // Firestore.instance
            //     .collection('users')
            //     .document(userDTO.userId.toString())
            //     .setData({
            //   'nickname': userDTO.firstName + " " + userDTO.lastName,
            //   'photoUrl': userDTO.profileImage,
            //   'id': userDTO.userId.toString(),
            //   'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            //   'chattingWith': null
            // });

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

            moveToHomeScreen();
          } else if (value.statusCode == 422) {
            print("data");

            Toast.show("The provided credentials are incorrect.", textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else if (value.statusCode == 403) {
            Toast.show("User is not found in our system.",textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            Toast.show("Something went wrong!",textStyle: TextStyle(),
                duration: Toast.lengthLong, gravity: Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  moveToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BottomNav(1)));


  }

}
