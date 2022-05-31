import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Validator/Validator.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:toast/toast.dart';

class UpdateUserInfo extends StatefulWidget {
  final String isUpdate;
  final UserModel userDetail;
  final String password;

  UpdateUserInfo({this.isUpdate="", required this.userDetail, this.password=""});

  @override
  _UpdateUserInfoState createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _interestedInController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final validator = Validator();
  List<GenderListModel> genderList = [];
  List<GenderListModel> interestedList = [];
  GenderListModel ? selected;

  @override
  void initState() {
    super.initState();

    selected = widget.userDetail.user_info.gender;

    widget.isUpdate == "gender" || widget.isUpdate == "interestedin"
        ? _genderList()
        : null;
    setFieldData();
    _aboutMeController.addListener(onValueChange);
  }

  void onValueChange() {
    setState(() {
      _aboutMeController.text;
    });
  }

  setFieldData() {
    setState(() {
      widget.isUpdate == "name"
          ? _nameController.text = widget.userDetail.name
          : widget.isUpdate == "age"
              ? _ageController.text = widget.userDetail.user_info.age.toString()
              : widget.isUpdate == "aboutme"
                  ? _aboutMeController.text =
                      widget.userDetail.user_info.about_me
                  : widget.isUpdate == "gender"
                      ? selected = widget.userDetail.user_info.gender
                      // : widget.isUpdate == "interestedin"
                      // ? _selectedInterested =
                      //     widget.userDetail.user_info.intrested_in
                      : widget.isUpdate == "password"
                          ? _passwordController.text = widget.password
                          : null;
    });

    print("password ${widget.password}");
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
        title: Text('Update User Info',
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
            Column(children: [
              SizedBox(
                height: 30.0,
              ),
              widget.isUpdate == "name"
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Name',
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
                    )
                  : Container(),
              widget.isUpdate == "age"
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              hintText: 'Age',
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
                    )
                  : Container(),
              widget.isUpdate == "aboutme"
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(250),
                            ],
                            maxLength: 250,
                            controller: _aboutMeController,
                            maxLines: null,
                            decoration: InputDecoration(
                              counterText:
                                  '${250 - _aboutMeController.text.length} / 250 words',
                              hintText: 'About Me',
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
                    )
                  : Container(),
              widget.isUpdate == "gender"
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected != null
                              ? Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: DropdownButton<GenderListModel>(
                                    value: selected,
                                    isExpanded: true,
                                    items: genderList
                                        .map<DropdownMenuItem<GenderListModel>>(
                                            (GenderListModel value) {
                                      return DropdownMenuItem<GenderListModel>(
                                        value: value,
                                        child: Text(value.gender),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        selected = value;
                                      });
                                    },
                                  ))
                              : Container(),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  : Container(),
              widget.isUpdate == "interestedin"
                  ? Expanded(
                      child: Container(
                        child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interested In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    interestedList.clear();
                                    setState(() {
                                      interestedList = genderList;
                                    });
                                    updateUserDetail();

                                    print("interestedList: $interestedList");
                                  },
                                  child: Text(
                                    'Select All',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            interestedList.length > 0
                                ? Container(
                                    // height: 80,
                                    padding: EdgeInsets.only(bottom: 80.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: MultiSelectDialogField(
                                      items: genderList
                                          .map((gender) =>
                                              MultiSelectItem<GenderListModel>(
                                                  gender, gender.gender))
                                          .toList(),
                                      title: Text("Interested In"),
                                      selectedColor: Colors.black,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.black,
                                      ),
                                      buttonText: Text(
                                        "Select any type",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (results) {
                                        interestedList!= results;
                                      },
                                      initialValue: interestedList,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              widget.isUpdate == "password"
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '********',
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
                    )
                  : Container(),
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  updateUserDetail();
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

  updateUserDetail() {
    var _name = _nameController.text;
    var _age = _ageController.text;
    var _aboutMe = _aboutMeController.text;
    var _pass = _passwordController.text;
    var _interested = _interestedInController.text;

    if (widget.isUpdate == "name") {
      if (validator.isNameTrue(_name)) {
        var userInfo = UserModel(
            widget.userDetail.id,
            _name,
            widget.userDetail.username,
            widget.userDetail.email,
            widget.userDetail.profile_image,
            widget.userDetail.profile_icon,
            widget.userDetail.user_info,
            widget.userDetail.latitude,
            widget.userDetail.longitude,
            widget.userDetail.interested,
            "1m");
        Navigator.pop(context, userInfo);
      } else {
        Toast.show("Name length must be greater than 2 character!", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (widget.isUpdate == "age") {
      if (_age.isNotEmpty && int.parse(_age) > 15) {
        var userInfoModel = UserInfoModel(
          int.parse(_age),
          widget.userDetail.user_info.ghost_mode,
          widget.userDetail.user_info.about_me,
          widget.userDetail.user_info.dob,
          widget.userDetail.user_info.gender,
        );
        var userInfo = UserModel(
            widget.userDetail.id,
            widget.userDetail.name,
            widget.userDetail.username,
            widget.userDetail.email,
            widget.userDetail.profile_image,
            widget.userDetail.profile_icon,
            userInfoModel,
            widget.userDetail.latitude,
            widget.userDetail.longitude,
            widget.userDetail.interested,
            "1m");
        Navigator.pop(context, userInfo);
      } else {
        Toast.show("Age must be above 15", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (widget.isUpdate == "aboutme") {
      if (_aboutMe.isNotEmpty && _aboutMe.length <= 250) {
        var userInfoModel = UserInfoModel(
          widget.userDetail.user_info.age,
          widget.userDetail.user_info.ghost_mode,
          _aboutMe,
          widget.userDetail.user_info.dob,
          widget.userDetail.user_info.gender,
        );
        var userInfo = UserModel(
            widget.userDetail.id,
            widget.userDetail.name,
            widget.userDetail.username,
            widget.userDetail.email,
            widget.userDetail.profile_image,
            widget.userDetail.profile_icon,
            userInfoModel,
            widget.userDetail.latitude,
            widget.userDetail.longitude,
            widget.userDetail.interested,
            "1m");
        Navigator.pop(context, userInfo);
      } else {
        Toast.show("Enter correct data", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (widget.isUpdate == "gender") {
      if (selected != null) {
        var userDetail = UserInfoModel(
          widget.userDetail.user_info.age,
          widget.userDetail.user_info.ghost_mode,
          widget.userDetail.user_info.about_me,
          widget.userDetail.user_info.dob,
          selected!,
        );
        var userInfo = UserModel(
            widget.userDetail.id,
            widget.userDetail.name,
            widget.userDetail.username,
            widget.userDetail.email,
            widget.userDetail.profile_image,
            widget.userDetail.profile_icon,
            userDetail,
            widget.userDetail.latitude,
            widget.userDetail.longitude,
            widget.userDetail.interested,
            "1m");
        Navigator.pop(context, userInfo);
      } else {
        Toast.show("Select gender type", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (widget.isUpdate == "interestedin") {
      if (interestedList.length > 0) {
        var userDetail = UserInfoModel(
          widget.userDetail.user_info.age,
          widget.userDetail.user_info.ghost_mode,
          widget.userDetail.user_info.about_me,
          widget.userDetail.user_info.dob,
          widget.userDetail.user_info.gender,
        );
        var userInfo = UserModel(
            widget.userDetail.id,
            widget.userDetail.name,
            widget.userDetail.username,
            widget.userDetail.email,
            widget.userDetail.profile_image,
            widget.userDetail.profile_icon,
            userDetail,
            widget.userDetail.latitude,
            widget.userDetail.longitude,
            interestedList,
            "1m");
        Navigator.pop(context, userInfo);
      } else {
        Toast.show("Select Interested types", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (widget.isUpdate == "password") {
      if (validator.isPasswordTrue(_pass)) {
        Navigator.pop(context, _pass);
      } else {
        Toast.show("Password length must be greater than 7 character!", textStyle: context,
            duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    }
  }

  _genderList() {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.genderList().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200 && value != null) {
            setState(() {
              genderList = value.data!.gender;

              for (int i = 0; i < genderList.length; i++) {
                if (genderList[i].id == widget.userDetail.user_info.gender.id) {
                  setState(() {
                    selected = genderList[i];
                  });
                }
              }

              if (widget.isUpdate == "interestedin") {
                var interestList = widget.userDetail.interested;
                for (int i = 0; i < genderList.length; i++) {
                  for (int j = 0; j < interestList.length; j++) {
                    if (interestList[j].id == genderList[i].id) {
                      setState(() {
                        interestedList.add(genderList[i]);
                      });
                    }
                  }
                }
              }

              print(interestedList.length);
            });
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: context,
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
