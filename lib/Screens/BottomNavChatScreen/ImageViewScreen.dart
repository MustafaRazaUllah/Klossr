import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:klossr/Constant/constants.dart';

class ImageViewScreen extends StatefulWidget {
  final String imageURL;
  const ImageViewScreen({required this.imageURL, Key? key}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.imageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        body: Center(
          child: Container(
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(hexToColor(primaryColor)),
                  ),
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(8.0),
                    // ),
                  ),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    'images/img_not_available.jpeg',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: widget.imageURL,
                // width: MediaQuery.of(context).size.width * 0.95,
                // height: MediaQuery.of(context).size.height * 0.8,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
            ),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          ),
        ));
  }
}
