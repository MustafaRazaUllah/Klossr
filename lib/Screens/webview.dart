import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final url;
  final title;
  const WebViewPage({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: widget.url, //'https://flutter.dev',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                // _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress%)');
              },
              javascriptChannels: <JavascriptChannel>{
                // _toasterJavascriptChannel(context),
              },
              // navigationDelegate: (NavigationRequest request) {
              //   if (request.url.startsWith('https://www.youtube.com/')) {
              //     print('blocking navigation to $request}');
              //     return NavigationDecision.prevent;
              //   }
              //   print('allowing navigation to $request');
              //   return NavigationDecision.navigate;
              // },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                // print('Page finished loading: $url');
                setState(() {
                  isLoading = false;
                });
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        );
      }),
    );
  }
}
