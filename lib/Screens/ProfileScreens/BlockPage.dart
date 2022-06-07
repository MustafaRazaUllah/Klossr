import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            Fluttertoast.showToast(
                msg: "Request already sent",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
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
          Fluttertoast.showToast(
              msg: "Unblocked",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 12.0);
          hideEasyLoading();
          if (value.statusCode == 200) {
            print("this is the id $id");
            Fluttertoast.showToast(
                msg: "Unblocked",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
            setState(() {
              allUsers.removeAt(index).id;
            });
          } else if (value.statusCode == 422) {
            Fluttertoast.showToast(
                msg: "User Unblock already",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }
}
