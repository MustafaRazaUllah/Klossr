import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Screens/BottomNavChatScreen/ImageViewScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Utilities/toast+klossr.dart';
import "package:klossr/extension/string_extension.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class UserChatScreen extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  UserChatScreen(
      {Key ? key, required this.peerId,
      required this.peerAvatar,
      required this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(peerAvatar),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${peerName.capitalize()} ",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
        centerTitle: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.8,
      ),
      body: new ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key ? key, required this.peerId, required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key ? key, required this.peerId, required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String ? id;

  var listMessage;
  String ? groupChatId;

  bool ? isLoading;
  String ? imageUrl;
  File ? imageFile;
  PermissionStatus ? permissionStatus;
  final picker = ImagePicker();

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    print("image: $peerAvatar");

    groupChatId = '';

    isLoading = false;

    readLocal();
  }

  readLocal() async {
    var fetchUserId = await SessionManager().getUserId();
    id = fetchUserId.toString();

    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    print("groupChatId $groupChatId");

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});
    print("njgjkgjkgk=====>");
    print(peerId);
    //
    // DocumentSnapshot s=await  FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(peerId).get();
    // print(s.get('pushToken'));
    // Map<String, dynamic>? data = querySnapshot.data();



    setState(() {});
  }

  Future<void> onSendMessage(String content, int type) async {
    //hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      DocumentSnapshot s=await  FirebaseFirestore.instance
          .collection('users')
          .doc(peerId).get();
      print("huigui");
      print(s.get('pushToken'));
      _sendAndRetrieveMessage(content,s.get('pushToken'));
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("something went wrong");
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Column(
        children: [
          Row(
            children: <Widget>[
              // Container(
              //   child: Text(
              //     document['content'],
              //     style: TextStyle(color: hexToColor(primaryColor)),
              //   ),
              //   padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              //   width: 200.0,
              //   decoration: BoxDecoration(
              //       color: hexToColor(rightMsgBackcolor),
              //       borderRadius: BorderRadius.circular(8.0)),
              //   margin: EdgeInsets.only(
              //       bottom: isLastMessageRight(index) ? 10.0 : 10.0,
              //       right: 10.0),
              // ),
              document['type'] == 0
                  // Text
                  ? Container(
                      child: Text(
                        emojiConverter(document['content']),
                        style: TextStyle(color: hexToColor(primaryColor)),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: hexToColor(rightMsgBackcolor),
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                          right: 10.0),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (document['content'] != null &&
                            document['content'] != "") {
                          // print("${document['content']}");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                        imageURL: document['content'],
                                      )));
                        }
                      },
                      child: Container(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    hexToColor(primaryColor)),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0),
                      ),
                    )
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          // isLastMessageRight(index)
          //     ? Container(
          //         child: Text(
          //           DateFormat('dd MMM kk:mm').format(
          //               DateTime.fromMillisecondsSinceEpoch(
          //                   int.parse(document['timestamp']))),
          //           style: TextStyle(
          //               color: Colors.grey,
          //               fontSize: 12.0,
          //               fontStyle: FontStyle.italic),
          //         ),
          //         margin: EdgeInsets.only(right: 0.0, top: 5.0, bottom: 5.0),
          //       )
          //     : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // Container(
                //   child: Text(
                //     document['content'],
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                //   width: 200.0,
                //   decoration: BoxDecoration(
                //       color: hexToColor(leftMsgBackColor),
                //       borderRadius: BorderRadius.circular(8.0)),
                //   margin: EdgeInsets.only(left: 10.0),
                // )
                // isLastMessageLeft(index)
                //     ? Material(
                //         child: CachedNetworkImage(
                //           placeholder: (context, url) => Container(
                //             child: CircularProgressIndicator(
                //               strokeWidth: 1.0,
                //               valueColor: AlwaysStoppedAnimation<Color>(
                //                   hexToColor(primaryColor)),
                //             ),
                //             width: 35.0,
                //             height: 35.0,
                //             padding: EdgeInsets.all(10.0),
                //           ),
                //           imageUrl: peerAvatar,
                //           width: 35.0,
                //           height: 35.0,
                //           fit: BoxFit.cover,
                //         ),
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(18.0),
                //         ),
                //         clipBehavior: Clip.hardEdge,
                //       )
                //     : Container(width: 35.0),
                // Container(
                //   child: Text(
                //     document['content'],
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                //   width: 200.0,
                //   decoration: BoxDecoration(
                //       color: hexToColor(primaryColor),
                //       borderRadius: BorderRadius.circular(8.0)),
                //   margin: EdgeInsets.only(left: 10.0),
                // )
                document['type'] == 0
                    ? Container(
                        child: Text(
                          emojiConverter(document['content']),
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: hexToColor(leftMsgBackColor),
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (document['content'] != null &&
                              document['content'] != "") {
                            // print("${document['content']}");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageViewScreen(
                                          imageURL: document['content'],
                                        )));
                          }
                        },
                        child: Container(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      hexToColor(primaryColor)),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          margin: EdgeInsets.only(left: 10.0),
                        ),
                      )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Input content
                buildInput(),
              ],
            ),
            buildLoading()
          ],
        ),
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading!
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        hexToColor(primaryColor))),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: // Edit text
                  Flexible(
                child: Container(
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: EdgeInsets.only(left: 15.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // added line
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.photo,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              getImage(1);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              getImage(2);
                            },
                          ),
                        ],
                      ),
                      border: InputBorder.none,
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  // Button send message
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () {
                        var message = textEditingController.text;
                        onSendMessage(emojiConverter(message), 0);
                      },
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
      ),
    );
  }
  Future<void> _sendAndRetrieveMessage(String message, String tokin) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."

    final yourServerKey =
        "AAAA8-vbQ9k:APA91bECW4-SOdJhxB-i-hXN0R-JRbkuH06zN_RjC6Ws1vLYDkhroNR4674GWMhkOvfPYVrf2Org-xVsX-qCOeknZGmFwFvI1GhSDWcsrBU_nNwI9uAMsJSOOn74jgwmKQqaGJMSkGkX";
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$yourServerKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': 'Message',
            // 'image':
            // 'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.
          // 'registration_ids': ["Your_FCM_Token_One", "Your_FCM_Token_Two"],
          'to': tokin
        },
      ),
    );
  }
  Widget buildListMessage() {
    Query query = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId!)
        .orderBy('timestamp', descending: true)
        .limit(20);
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(hexToColor(primaryColor))))
          : StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, stream) {
                if (stream.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (stream.hasError) {
                  return Center(child: Text(stream.error.toString()));
                }

                listMessage = stream.data?.docs;
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(index, stream.data!.docs[index]),
                  itemCount: stream.data!.docs.length,
                  reverse: true,
                  controller: listScrollController,
                );
              },
            ),
    );
  }

  Future getImage(int option) async {
    await Permission.camera.request();
    permissionStatus = await Permission.camera.status;

    if (permissionStatus!.isGranted) {
      final pickedFile = await picker.getImage(
          source: option == 1 ? ImageSource.gallery : ImageSource.camera,
          imageQuality: 50,
          maxHeight: 2000.0,
          maxWidth: 2000.0);

      setState(() {
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
          isLoading = true;
          print(imageFile);
          uploadFile();
        } else {
          print('No image selected.');
        }
      });
    } else {
      showAlertDialog(
          context: context,
          title: "Kameraberechtigung erforderlich!",
          content:
              "Offenbar haben Sie die Kameraberechtigung noch nicht erteilt. Bitte erteilen Sie der Kamera die Erlaubnis in den Einstellungen.",
          defaultActionText: "Einstellungen öffnen");
      showToast(
          "Bitte erteilen Sie die Kameraberechtigung und versuchen Sie es erneut",
          context);
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() async {
      imageUrl = await reference.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, 1);
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Toast.show("Something went wrong...",textStyle: context,
          duration: Toast.lengthLong, gravity: Toast.bottom);
    });
  }
}
