import 'package:flutter/material.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class AddSuggestionScreen extends StatefulWidget {
  const AddSuggestionScreen({Key? key}) : super(key: key);

  @override
  _AddSuggestionScreenState createState() => _AddSuggestionScreenState();
}

class _AddSuggestionScreenState extends State<AddSuggestionScreen> {
  final TextEditingController _genderController = TextEditingController();

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
          title: Text('Add Suggestion',
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
                        controller: _genderController,
                        decoration: InputDecoration(
                          hintText: 'Suggested ',
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
                          child: Text('Save',
                              style: TextStyle(color: Colors.white)),
                        )),
                  ),
                  onTap: () {
                    if (_genderController.text.isNotEmpty) {
                      suggestGender(_genderController.text);
                    } else {
                      Toast.show(
                        "Filed can\'t be empty",
                        textStyle: TextStyle(color: Colors.white),
                        duration: Toast.lengthLong,
                        gravity: Toast.center,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  suggestGender(String gender) {
    ToastContext().init(context);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.suggestGender(gender).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the gender valFue $gender");
            Toast.show("added successfully!",
                textStyle: TextStyle(color: Colors.white),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent",
                textStyle: TextStyle(color: Colors.white),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          } else {
            Toast.show("Something went wrong!",
                textStyle: TextStyle(color: Colors.white),
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
