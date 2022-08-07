import 'package:flutter/material.dart';
import 'package:klossr/Screens/AddSuggestionScreen.dart';
import '../webview.dart';
import 'BlockPage.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({Key? key}) : super(key: key);

  @override
  _UserSettingScreenState createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
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
        title: Text('Settings',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Block list',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BlockPage()));
                  },
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSuggestionScreen()));
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add Suggestion',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),

                // GestureDetector(
                //   child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 20.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Notification settings',
                //               style: TextStyle(
                //                 fontSize: 17,
                //                 fontWeight: FontWeight.w400,
                //               )),
                //           Icon(
                //             Icons.chevron_right,
                //             color: Colors.black26,
                //             size: 33,
                //           )
                //         ],
                //       )),
                //   onTap: () {
                //     // Navigator.push(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (context) => NotificationsSettings()));
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // Divider(
                //   thickness: 0.8,
                //   color: Colors.black26,
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // GestureDetector(
                //   child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 20.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Feedback',
                //               style: TextStyle(
                //                 fontSize: 17,
                //                 fontWeight: FontWeight.w400,
                //               )),
                //           Icon(
                //             Icons.chevron_right,
                //             color: Colors.black26,
                //             size: 33,
                //           )
                //         ],
                //       )),
                //   onTap: () {
                //     // Navigator.push(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (context) => FeedbackPage()));
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // Divider(
                //   thickness: 0.8,
                //   color: Colors.black26,
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                GestureDetector(
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact us',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url: "https://www.klosrr.com/contact-us/",
                              title: "Contact us",
                            )));
                  },
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            url: "https://klosrr.com/privacy-policy",
                            title: "Privacy Policy",
                          ),
                          // MyWebView(
                          //   url: "https://klosrr.com/privacy-policy",
                          //   title: "Privacy Policy",
                          // ),
                        ));
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Privacy policy',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                  url:
                                      "https://klosrr.com/terms-and-conditions",
                                  title: "Terms & Conditions",
                                )));
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Terms and Conditions',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                  url: "https://klosrr.com/disclaimer",
                                  title: "Disclaimer",
                                )));
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Disclaimer',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                            size: 33,
                          )
                        ],
                      )),
                ),

                Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:GestureDetector (
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20.0),
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child: Text('Save', style: TextStyle(color: Colors.white)),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
