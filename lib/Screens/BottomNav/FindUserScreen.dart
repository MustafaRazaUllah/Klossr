import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Network/DTOs/NearByUserDTO.dart';
import 'package:klossr/Screens/NearbyUserCardScreen/RequestChatScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Utilities/toast+klossr.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as myPermission;
import "package:klossr/extension/string_extension.dart";

class FindUserScreen extends StatefulWidget {
  const FindUserScreen({Key? key}) : super(key: key);

  @override
  _FindUserScreenState createState() => _FindUserScreenState();
}

class _FindUserScreenState extends State<FindUserScreen> {
  myPermission.PermissionStatus? permissionStatus;
  Location _location = Location();
  List<UserModel> allUsers = [];
  int index = 0;
  // double mileDistance = 0.0;
  // double mileValue = 0.000621;
  bool isLoading = false;
  var userId;
  var token;
  @override
  void initState() {
    super.initState();
    getUserId();
    _refreshAllNearByZones();
  }

  getUserId() async {
    userId = await SessionManager().getUserId();
    print("userId");
    print(userId);

    token = await SessionManager().getUserToken();
  }

  _refreshAllNearByZones() async {
    if (await _location.hasPermission() != null) {
      checkInternet().then((value) async {
        if (value) {
          showEasyloaging();
          final pos = await _location.getLocation().then((value) {
            double? lat = value.latitude;
            double? long = value.longitude;
            UserUseCase userUseCase = new UserUseCase();
            userUseCase
                .getNearbyZones(lat.toString(), long.toString())
                .then((value) {
              hideEasyLoading();
              if (value.statusCode == 200) {
                setState(() {
                  allUsers = value.data!.data;
                  // mileDistance = allUsers[index].distance * mileValue;
                });
              } else
                showToast("Something went wrong", context);
            });
          });
        } else
          noInternetConnectionMethod(context);
      });
    } else
      _location.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0,
          toolbarHeight: 0.0,
        ),
        body: Container(
          child: allUsers.length > 0
              ? Column(
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // print(index);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestChatScreen(
                                      allUsers[index], userId))).then((value) {
                            print(value);
                            if (value == true) {
                              // print(index);
                              setState(() {
                                allUsers.removeAt(index);
                              });
                            }
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.transparent,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    // 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cGVyc29ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'
                                    allUsers[index].profile_image,
                                  ),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 1.4,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 1.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.grey.withOpacity(0.0),
                                    Colors.black,
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 20.0,
                                left: 20.0,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${allUsers[index].name.capitalize()} , ${allUsers[index].user_info.age.toString()}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        allUsers[index]
                                            .distance, // mileDistance.toStringAsFixed(2) +
                                        // " " +
                                        // "mi",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 57, right: 57),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // print(index);
                                  if (index == (allUsers.length - 1)) {
                                    setState(() {
                                      allUsers.removeAt(allUsers.length - 1);
                                    });
                                    // showToast("No any new user found!", context);
                                  } else {
                                    setState(() {
                                      allUsers.removeAt(index);
                                    });
                                    // setState(() {
                                    //   index += 1;
                                    //   mileDistance =
                                    //       (allUsers[index].distance + mileValue);
                                    // });
                                  }
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 34,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestChatScreen(
                                                      allUsers[index], userId)))
                                      .then((value) {
                                    print(value);
                                    if (value == true) {
                                      setState(() {
                                        allUsers.removeAt(index);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                    "Check later to see if there are any new friends.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ));
  }
}
