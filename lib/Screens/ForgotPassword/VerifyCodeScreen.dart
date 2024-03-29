import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klossr/Screens/ForgotPassword/UpdatePasswordScreen.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Validator/Validator.dart';
import 'package:toast/toast.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

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
          title: Text('Verify Code',
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
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: 'Enter Code',
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
                          child: Text('Continue',
                              style: TextStyle(color: Colors.white)),
                        )),
                  ),
                  onTap: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    final _code = _codeController.text;
                    print("object=============>>>>>>>>>+++++++++>>>>>>");
                    print(_code);
                    if (_code.isNotEmpty && _code.length == 6) {
                      verifyCodeMethod(_code);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Code is incorrect.",
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

  verifyCodeMethod(String code) {
    print("object=============>>>>>>>>>+++++++++>>>>>>");
    print(code);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.verifyCode(code).then((value) {
          hideEasyLoading();
          print(value.toString());
          if (value.statusCode == 200) {
            print("Success");
            final code = value.data!.remember_token;
            print(code);
            Fluttertoast.showToast(
                msg: "OTP Verify Successfully",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdatePasswordScreen(
                  rememberCode: code,
                ),
              ),
            );
          } else if (value.statusCode == 404) {
            Fluttertoast.showToast(
                msg: "Verification code is incorrect.",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
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
