import 'package:flutter/material.dart';
import 'package:klossr/Screens/ForgotPassword/VerifyCodeScreen.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Validator/Validator.dart';
import 'package:toast/toast.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key?  key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final validator = Validator();

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
          title: Text('Verify Email',
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
                        "Enter the email address associated with your account, we'll email you a verification code.", //'Suggested Gender',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email ',
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
                    final _email = _emailController.text;

                    if (_email.isNotEmpty && validator.isEmailTrue(_email)) {
                      verifyEmailMethod(_emailController.text);
                    } else {
                      Toast.show("Email is incorrect.", textStyle: context,
                          duration: Toast.lengthLong, gravity: Toast.center);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  verifyEmailMethod(String email) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.verifyEmail(email).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // Toast.show("Mail send Successfully.", context,
            //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerifyCodeScreen()));
          } else if (value.statusCode == 404) {
            Toast.show("Email is incorrect.", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else {
            Toast.show("Something went wrong!", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.bottom);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
