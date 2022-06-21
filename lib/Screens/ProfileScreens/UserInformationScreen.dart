import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserInfoRequest.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/ProfileScreens/UpdateUserInfo.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Utilities/toast+klossr.dart';
import 'package:toast/toast.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  var name = "",
      userName = "",
      age = 0,
      email = "",
      aboutMe = "",
      ghostMode = false,
      password = "",
      token = "",
      image = "",
      profileIcon = "",
      dob = "";
  double? lat, long;
  GenderListModel? gender;
  List<GenderListModel> interestedIn = [];
  int? id;
  String dateSelected = "Select your Birth Date";
  bool isDateSelected = false;
  String? birthDateInString;
  DateTime? birthDate;

  var userModel;
  UserUseCase userUseCase = new UserUseCase();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) => {getUserInfo()});
  }

  getUserInfo() async {
    checkInternet().then((value) async {
      if (value) {
        showEasyloaging();
        userUseCase.getUserDetail().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            UserModel user = value.data!.user;
            setUserInfo(user);
            print(value.data!.user.toJson());
          } else
            showToast("Something went wrong", context);
        });
      } else
        noInternetConnectionMethod(context);
    });
  }

  setUserInfo(UserModel user) async {
    var _pass = await SessionManager().getPassword();
    var _token = await SessionManager().getUserToken();
    var _userInfo;

    setState(() {
      id = user.id;
      name = user.name;
      userName = user.username;
      email = user.email;
      age = user.user_info.age;
      aboutMe = user.user_info.about_me;
      ghostMode = user.user_info.ghost_mode;
      gender = user.user_info.gender;
      interestedIn = user.interested;
      password = _pass;
      token = _token;
      image = user.profile_image;
      profileIcon = user.profile_icon;
      lat = user.latitude;
      long = user.longitude;
      dob = user.user_info.dob;

      _userInfo = UserInfoModel(
        age,
        ghostMode,
        aboutMe,
        dob,
        gender!,
      );
      userModel = UserModel(id!, name, userName, email, image, profileIcon,
          _userInfo, lat!, long!, interestedIn, "1m");
    });
  }

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
        title: Text('User Info',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.white,
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfo(
                          isUpdate: "name",
                          userDetail: userModel,
                        ),
                      ),
                    ).then((value) => {
                          if (value.name != name) {updateName(value)}
                        });
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(name,
                            style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => UpdateUserInfo()));
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(userName,
                            style:
                                TextStyle(color: Colors.black26, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(email,
                            style:
                                TextStyle(color: Colors.black26, fontSize: 15))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                // GestureDetector(
                //   child: Container(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text('Age',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.w500,
                //             )),
                //         Text(age.toString(),
                //             style: TextStyle(color: Colors.grey, fontSize: 15))
                //       ],
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => UpdateUserInfo(
                //           isUpdate: "age",
                //           userDetail: userModel,
                //         ),
                //       ),
                //     ).then((value) => {updateAge(value)});
                //   },
                // ),
                // SizedBox(
                //   height: 30.0,
                // ),
                GestureDetector(
                  onTap: () {
                    _showDatePicker(context);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DOB',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(isDateSelected ? birthDateInString! : dob,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey, fontSize: 13))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About me',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            //'Hi I am Sophia Ava. Hi I am Sophia Ava. Hi I am Sophia Ava. Hi I am Sophia Ava. Hi I am Sophia Ava. ',
                            aboutMe,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey, fontSize: 13))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfo(
                          isUpdate: "aboutme",
                          userDetail: userModel,
                        ),
                      ),
                    ).then((value) => {
                          if (value.user_info.about_me != aboutMe)
                            {updateAboutMe(value)}
                        });
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                // Container(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text('My Location',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,
                //           )),
                //       Row(
                //         children: [
                //           Text('Ghost Mode',
                //               style:
                //                   TextStyle(color: Colors.grey, fontSize: 15)),
                //           Container(
                //             child: CupertinoSwitch(
                //               activeColor: Colors.black,
                //               value: ghostMode,
                //               onChanged: (value) {
                //                 setState(() {
                //                   ghostMode = value;
                //                 });
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 30.0,
                // ),
                GestureDetector(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(gender != null ? gender!.gender : "",
                            style: TextStyle(color: Colors.grey, fontSize: 15))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfo(
                          isUpdate: "gender",
                          userDetail: userModel,
                        ),
                      ),
                    ).then((value) => {updateGender(value)});
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Interested in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 50.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < interestedIn.length; i++)
                              Text(interestedIn[i].gender + ", ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfo(
                          isUpdate: "interestedin",
                          userDetail: userModel,
                        ),
                      ),
                    ).then((value) => {
                          updateInterestedIn(value),
                        });
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text('********',
                            style: TextStyle(color: Colors.grey, fontSize: 15))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfo(
                          isUpdate: "password",
                          userDetail: userModel,
                          password: password,
                        ),
                      ),
                    ).then((value) => {
                          if (value.isNotEmpty && value != password)
                            {updatePassword(value)}
                        });
                  },
                ),
                SizedBox(
                  height: 80.0,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _saveMethod();
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(ctx) async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1980),
        lastDate: DateTime.now());
    if (datePick != null) {
      setState(() {
        birthDate = datePick;
        isDateSelected = true;
        print("isDateSelected");
        print(isDateSelected);

        birthDateInString =
            "${birthDate!.year}-${birthDate!.month}-${birthDate!.day}"; // 2019-08-14
        print("isDateSelected");
        print(isDateSelected);
      });
    }
    print("isDateSelected");
    print(isDateSelected);
  }

  bool isAdult(String birthDateString) {
    String datePattern = "yyyy-MM-dd";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
  }

  _saveMethod() {
    ToastContext().init(context);
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      var isGhostMode = 0;
      var birthDate = "";
      List<int> isInterestedIn = [];
      isGhostMode = ghostMode ? 1 : 0;

      if (interestedIn.length > 0) {
        for (int i = 0; i < interestedIn.length; i++) {
          isInterestedIn.add(interestedIn[i].id);
        }
      }

      if (dob != null || isDateSelected) {
        birthDate = dob;
        print("dob");
        print(dob);
        print(birthDate);
        if (isDateSelected) {
          print("ooo");
          if (isAdult(birthDateInString!)) {
            print("Enter");
            birthDate = birthDateInString!;
            print("birthDate");
            print(birthDate);
          } else {
            print("brthDate");
            Toast.show(
              "You should be 18 years old.",
              textStyle: TextStyle(color: Colors.white),
              duration: Toast.lengthLong,
              gravity: Toast.center,
            );
            return;
          }
        }
      } else {
        Toast.show(
          dateSelected,
          textStyle: TextStyle(color: Colors.white),
          duration: Toast.lengthLong,
          gravity: Toast.center,
        );
      }

      if (aboutMe.isEmpty || aboutMe == null) {
        Toast.show(
          "The about me field is required",
          textStyle: TextStyle(color: Colors.white),
          duration: Toast.lengthLong,
          gravity: Toast.center,
        );
        return;
      }

      print(
          "name: $name, username: $userName, email: $email, age: $age, DOB: $birthDate, about_me : $aboutMe, ghost: $isGhostMode, gender: ${gender!.id}, interested: $isInterestedIn, password: $password");

      var updatedUserDetail = UserInfoRequestModel(
        name,
        userName,
        email,
        birthDate,
        aboutMe,
        isGhostMode,
        gender!.id,
        isInterestedIn,
      );
      if (value) {
        showEasyloaging();
        userUseCase.updateUserInfo(updatedUserDetail).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            Toast.show(
              "Profile are updated successfully.",
              textStyle: TextStyle(color: Colors.white),
              duration: Toast.lengthLong,
              gravity: Toast.center,
            );

            SessionManager().setUserInfo(
                token,
                name,
                userName,
                email,
                age,
                ghostMode,
                aboutMe,
                // interestedIn,
                null,
                null,
                password,
                image);

            Navigator.pop(context);
          } else {
            Toast.show(
              "Something went wrong!",
              textStyle: TextStyle(color: Colors.white),
              duration: Toast.lengthLong,
              gravity: Toast.center,
            );
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  updateName(UserModel userInfo) {
    UpdateModelValues(userInfo);
    setState(() {
      name = userInfo.name;
    });
  }

  updateAge(UserModel userInfo) {
    UpdateModelValues(userInfo);
    setState(() {
      age = userInfo.user_info.age;
    });
  }

  updateAboutMe(UserModel userInfo) {
    UpdateModelValues(userInfo);
    setState(() {
      aboutMe = userInfo.user_info.about_me;
    });
  }

  updateGender(UserModel userInfo) {
    UpdateModelValues(userInfo);
    setState(() {
      gender = userInfo.user_info.gender;
    });
  }

  updateInterestedIn(UserModel userInfo) {
    UpdateModelValues(userInfo);
    setState(() {
      interestedIn = userInfo.interested;
    });
  }

  updatePassword(String pass) {
    setState(() {
      password = pass;
    });
  }

  UpdateModelValues(UserModel userInfo) {
    var _userInfo = UserInfoModel(
      userInfo.user_info.age,
      userInfo.user_info.ghost_mode,
      userInfo.user_info.about_me,
      userInfo.user_info.dob,
      userInfo.user_info.gender,
    );
    userModel = UserModel(
        userInfo.id,
        userInfo.name,
        userInfo.username,
        userInfo.email,
        userInfo.profile_image,
        userInfo.profile_icon,
        userInfo.user_info,
        userInfo.latitude,
        userInfo.longitude,
        userInfo.interested,
        "1m");
  }
}
