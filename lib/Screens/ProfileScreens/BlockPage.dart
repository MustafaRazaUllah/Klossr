import 'package:flutter/material.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/BottomNav.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:toast/toast.dart';

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  List<UserModel> allUsers = [];

  @override
  void initState() {
    blockList();
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
        title: Text('Block List',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
      ),
      body: allUsers.length == 0
          ? Center(
              child: Text(
                "Empty!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        foregroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(
                                            // 'https://cdn.pixabay.com/photo/2018/01/21/14/16/woman-3096664__340.jpg'
                                            allUsers[index].profile_image),
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Text(allUsers[index].name),
                                    ]),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10.0),
                                  GestureDetector(
                                    onTap: () {
                                      //  unFriend(allUsers[index].id.toString(), index);
// <<<<<<< HEAD
// =======
//                                       // print(index);
// >>>>>>> 20432d7b0e8301db655d043bc1790e1a9b58909e
                                      unBlock(
                                          allUsers[index].id.toString(), index);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      // color: Colors.red,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Text('Unblock',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  blockList() {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.blockList().then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            // print("This is the data ${value.data.data.length}");
            setState(() {
              allUsers = value.data!.data;
              print("this is all block record $allUsers");
            });
            // Navigator.pop(context);
          } else if (value.statusCode == 422) {
            Toast.show("Request already sent", textStyle: context,
                duration: Toast.lengthLong ,gravity: Toast.bottom);
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

  requestAccept(String user_id, int index) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.requestAccept(user_id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            Toast.show("Request accept successfully!", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.bottom);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNav(1)));
          } else if (value.statusCode == 404) {
            Toast.show("Request already accepted", textStyle: context,
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

  requestReject(String user_id, int index) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.requestReject(user_id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the user id $user_id");
            Toast.show("Request decline successfully!", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.bottom);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNav(1)));
            // setState(() {
            //   allUsers.removeAt(index);
            // });
          } else if (value.statusCode == 404) {
            Toast.show("Request already declined", textStyle: context,
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

  unBlock(String id, int index) {
    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      if (value) {
        showEasyloaging();
        userUseCase.unBlock(id).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the id $id");
            Toast.show("Unblocked", textStyle: context,
                duration: Toast.lengthLong, gravity: Toast.bottom);
            setState(() {
              allUsers.removeAt(index).id;
            });
          } else if (value.statusCode == 422) {
            Toast.show("User Unblock already", textStyle: context,
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
