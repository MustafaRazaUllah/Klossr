import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klossr/Screens/LoginScreen.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String rememberCode;
  const UpdatePasswordScreen({required this.rememberCode, Key? key})
      : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  // FirebaseMessaging  _firebaseMessaging=FirebaseMessaging.instance;
  // var token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("code is : ${widget.rememberCode}");
  }
  // getFCMToken() async {
  //
  //   token = await _firebaseMessaging.getToken();
  //   print("toto $token");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.5),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          title: Text('Update Password',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
        ),
        body: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "", //'Suggested Gender',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 40),
                        height: 45.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                          child: Text('Update Password',
                              style: TextStyle(color: Colors.white)),
                        )),
                  ),
                  onTap: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    final _password = _passwordController.text;
                    if (_password.isNotEmpty && _password.length == 8) {
                      updatePasswordMethod(_password);
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Password is incorrect or should be 8 characters.",
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  updatePasswordMethod(String password) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.updatePassword(password, widget.rememberCode).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // Toast.show("Password Updated Successfully.",
            //     textStyle: TextStyle(),
            //     duration: Toast.lengthLong,
            //     gravity: Toast.center);
            Fluttertoast.showToast(
                msg: "Password Updated Successfully.",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
