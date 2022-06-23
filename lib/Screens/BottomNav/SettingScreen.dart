import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imgLib;
import 'package:image_picker/image_picker.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/LoginScreen.dart';
import 'package:klossr/Screens/ProfileScreens/UserInformationScreen.dart';
import 'package:klossr/Screens/ProfileScreens/UserSettingScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Utilities/profile_clipper.dart';
import 'package:klossr/Utilities/toast+klossr.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'file_from_imageurl.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<String> menuList = ["User Info", "Settings", "Logout"];
  List<UserModel> allUsers = [];
  var image = "";
  FirebaseMessaging? _firebaseMessaging;
  PermissionStatus? permissionStatus;
  // File imageFile = File("");
  String iamgesFile = "assets/profile_picture.png";

  File imageFile = File("");
  final picker = ImagePicker();
// var token;
  UserUseCase userUseCase = new UserUseCase();

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) => {});
    // Future.delayed(Duration.zero).then((value) => {getFCMToken()});
    // TODO: implement initState
    super.initState();
    getUserImage();
  }
  // getFCMToken() async {
  //
  //   token = await _firebaseMessaging?.getToken();
  //   print("toto $token");
  // }

  getUserImage() async {
    var _image = await SessionManager().getImage();

    var fileName = await fileFromImageUrl(_image);
    print("out source" + fileName.toString());
    setState(
      () {
        imageFile = File(fileName.path);
      },
    );
  }

  updateUserImage(File fileImage) {
    print(fileImage);
    checkInternet().then((value) async {
      if (value) {
        showEasyloaging();
        userUseCase.updateImage(fileImage).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            var imageUrl = value.data!.image_url;
            print(imageUrl +
                "New Updated Image of User===================================>>>>>>>>>>>>>>>>>>>");
            SessionManager().setImage(imageUrl);
            showToast("Image Updated!", context);
          } else
            showToast("Something went wrong", context);
        });
      } else
        noInternetConnectionMethod(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var profile_image;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          elevation: 0,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipPath(
                    clipper: ProfileClipper(),
                    child: Container(
                      height: 200.0,
                      width: double.infinity,
                      color: Colors.black,
                    )),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            spreadRadius: 5)
                      ],
                    ),
                    child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: imageFile == null
                            ? SizedBox(
                                height: 130,
                                width: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    "assets/profile_picture.png",
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 60.0,
                                backgroundColor: Colors.white,
                                backgroundImage: FileImage(imageFile),
                              )
                        // : SizedBox(
                        //     height: 130,
                        //     width: 130,
                        //     child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(100),
                        //       child: Image.asset(
                        //         "assets/profile_picture.png",
                        //       ),
                        //     ),
                        //   ),
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            _buildMenu(0),
            _buildMenu(1),
            _buildMenu(2),
          ],
        ),
      ),
    );
  }

  _buildMenu(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: GestureDetector(
        child: Container(
          height: 50,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: hexToColor(backgroundGreyColor),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey, width: 0.1)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  index == 0
                      ? CupertinoIcons.profile_circled
                      : index == 1
                          ? CupertinoIcons.settings
                          : CupertinoIcons.square_arrow_right,
                  size: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(menuList[index],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        onTap: () {
          if (index == 0 || index == 1) {
            var nextRoute =
                index == 0 ? UserInformationScreen() : UserSettingScreen();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => nextRoute));
          } else {
            logoutMethod();
          }
        },
      ),
    );
  }

  logoutMethod() async {
    await SessionManager().Logout();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _showPicker(context) {
    final act = CupertinoActionSheet(
        title: Text('Title'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              'Gallery',
              style: TextStyle(color: hexToColor(secondryColor)),
            ),
            onPressed: () {
              print(
                'Photo Library',
              );
              Navigator.of(context, rootNavigator: true).pop(
                "Gallery",
              );
              Future.delayed(const Duration(milliseconds: 600), () {
                setState(() {
                  openCamera(context, 1);
                });
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Camera',
              style: TextStyle(color: hexToColor(secondryColor)),
            ),
            onPressed: () {
              print('Camera');
              Navigator.of(context, rootNavigator: true).pop("Camera");
              Future.delayed(const Duration(milliseconds: 600), () {
                setState(() {
                  openCamera(context, 2);
                });
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Remove profile image',
              style: TextStyle(color: hexToColor(secondryColor)),
            ),
            onPressed: () async {
              print('Remove profile image');
              // var imagePath = "https://picsum.photos/200";
              // var imagePath = "assets/profile_picture.png";
              var imagePath =
                  "https://firebasestorage.googleapis.com/v0/b/klosrr-4fd55.appspot.com/o/default-profile-picture-circle-hd-png-download.png?alt=media&token=2b5e7163-9043-4908-9456-617008b7af11";
              // var f = await urlToFile(imagePath);
              var f = await urlToFile(imagePath);
              print("image-->> " + f.toString());
              setState(() {
                imageFile = f;
              });
              updateUserImage(f);
              Navigator.of(context, rootNavigator: true)
                  .pop("Remove profile image");
              // Future.delayed(const Duration(milliseconds: 600), () async {

              // });
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'Cancel',
            style: TextStyle(color: hexToColor(secondryColor)),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop("Cancel");
          },
        ));
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }

  void openCamera(dialogContext, int option) async {
    //edit here
    await Permission.camera.request();
    permissionStatus = await Permission.camera.status;

    if (permissionStatus!.isGranted) {
      final pickedFile = await picker.getImage(
        source: option == 1 ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50,
        // maxHeight: 500.0,
        // maxWidth: 500.0
      );

      // imgLib.Image image =
      //     imgLib.decodeJpg(File(pickedFile.path).readAsBytesSync());
      // imgLib.Image thumbnail =
      //     imgLib.copyResize(image, width: 100, height: 100);
      // final resizeImg = new File('out/thumbnail-test.png')
      //   ..writeAsBytesSync(imgLib.encodePng(thumbnail));

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        print("after object=+++++Local Image Path" + imageFile.toString());
        var finalImage = resizeMyImage(imageFile);
        print("image-->> " + finalImage.toString());
        finalImage.then((value) {
          print(value.path);
          updateUserImage(value);
        });
      } else {
        print('No image selected.');
      }
      setState(() {});
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

  Future<File> resizeMyImage(File resizeThisFile) async {
    String tempPath;
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    // decodeImage will identify the format of the image and use the appropriate
    // decoder.
    File myCompressedFile;
    imgLib.Image? image = imgLib.decodeImage(resizeThisFile.readAsBytesSync());

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    imgLib.Image thumbnail = imgLib.copyResize(image!, width: 500, height: 500);

    // Save the thumbnail as a PNG.
    print('resizeMyImage............tempPath: ' + tempPath);
    myCompressedFile = new File(tempPath + 'thumbnail.png')
      ..writeAsBytesSync(imgLib.encodePng(thumbnail));

    return myCompressedFile;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }
}
