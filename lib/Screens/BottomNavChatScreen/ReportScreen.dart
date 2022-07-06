import 'package:flutter/material.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class ReportScreen extends StatefulWidget {
  String user_id;
  ReportScreen(this.user_id);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController messageTextController = new TextEditingController();

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
        title: Text('Report',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          // color: Colors.black26,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 10.0),
                height: 400,
                width: double.infinity,
                // color: Colors.black87,
                child: TextFormField(
                  controller: messageTextController,
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: 'Write a message.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 40, horizontal: 20.0),
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                    )),
                onTap: () {
                  var message = messageTextController.text;
                  if (message.isEmpty || message == null) {
                    Toast.show("Please enter some text", textStyle: context,
                        duration: Toast.lengthLong, gravity: Toast.center);
                  } else {
                    report(widget.user_id, message);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  report(String user_report, String message) {
    print("report $user_report, $message");
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.report(user_report, message).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            Toast.show(value.data!.message, textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.center);
            messageTextController.clear();
          } else if (value.statusCode == 422) {
            Toast.show("Already Reported", textStyle: context,
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
