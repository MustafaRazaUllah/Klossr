import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebView extends StatefulWidget {
  String url;
  String title;
  MyWebView({Key ? key, required this.url, required this.title}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool isLoading = true;
  bool isError = false;
  final _key = UniqueKey();

  //inappwebview
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController ? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
          // useHybridComposition: true,
          ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(widget.title, style: TextStyle(color: Colors.black),),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
            key: webViewKey,
            initialFile: widget.url,
            // initialUrlRequest: URLRequest(url: Uri.parse(url)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {},
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {
              setState(() {
                isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
              });
            },
            // androidOnGeolocationPermissionsShowPrompt:
            //     (InAppWebViewController controller, String origin) async {
            //   bool result = await showDialog(
            //     context: context,
            //     barrierDismissible: false, // user must tap button!
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //         title: Text('Allow access location $origin'),
            //         content: SingleChildScrollView(
            //           child: ListBody(
            //             children: [
            //               Text('Allow access location $origin'),
            //             ],
            //           ),
            //         ),
            //         actions: [
            //           TextButton(
            //             child: Text('Allow'),
            //             onPressed: () {
            //               Navigator.of(context).pop(true);
            //             },
            //           ),
            //           TextButton(
            //             child: Text('Denied'),
            //             onPressed: () {
            //               Navigator.of(context).pop(false);
            //             },
            //           ),
            //         ],
            //       );
            //     },
            //   );
            //   if (result) {
            //     return Future.value(GeolocationPermissionShowPromptResponse(
            //         origin: origin, allow: true, retain: true));
            //   } else {
            //     return Future.value(GeolocationPermissionShowPromptResponse(
            //         origin: origin, allow: false, retain: false));
            //   }

            //   // return GeolocationPermissionShowPromptResponse(
            //   //     origin: origin, allow: true, retain: true);
            // },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
          !isLoading && isError
              ? const Center(
                  child: Text(
                    "The resource could not be loaded",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
        ],
      ),
    );
    // Container(
    //   color: Colors.white,
    //   child: SafeArea(
    //     child:
    //   ),
    // );
  }

  // body() {
  //   return Container(
  //     color: Colors.white,
  //     child: SafeArea(
  //       child: Scaffold(
  //         // appBar: AppBar(
  //         //     title: Text(
  //         //       title,
  //         //       style: const TextStyle(fontWeight: FontWeight.w700),
  //         //     ),
  //         //     centerTitle: true),
  //         body: Stack(
  //           children: <Widget>[
  //             WebView(
  //               key: _key,
  //               initialUrl: url,
  //               javascriptMode: JavascriptMode.unrestricted,
  //               onPageFinished: (finish) {
  //                 setState(() {
  //                   isLoading = false;
  //                 });
  //               },
  //               onWebResourceError: (WebResourceError webviewerrr) {
  //                 setState(() {
  //                   isLoading = false;
  //                   isError = true;
  //                 });
  //                 // print(webviewerrr.description);
  //               },
  //             ),
  //             isLoading
  //                 ? const Center(
  //                     child: CircularProgressIndicator(),
  //                   )
  //                 : Stack(),
  //             !isLoading && isError
  //                 ? const Center(
  //                     child: Text(
  //                       "The resource could not be loaded",
  //                       style: TextStyle(
  //                           fontSize: 18.0, fontWeight: FontWeight.bold),
  //                     ),
  //                   )
  //                 : Container(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
