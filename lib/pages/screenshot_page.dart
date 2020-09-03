import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotScreen extends StatefulWidget {
  ScreenshotScreen({Key key}) : super(key: key);
  static const routeName = "screnshot_screen";
  @override
  _ScreenshotScreenState createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen> {
  bool init = false;
  bool loading = true;
  File image;
  String verseSanskrit = "";
  String translation = "";
  String title = "";
  ScreenshotController screenshotController = ScreenshotController();

  int _counter = 0;
  File _imageFile;

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      image = args["image"];
      title = args["title"];
      verseSanskrit = args["verseSanskrit"];
      translation = args["translation"];

      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? CircularProgressIndicator()
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Image.file(image,
                                  color: Colors.black.withOpacity(0.2),
                                  colorBlendMode: BlendMode.darken,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width),
                              BlurryContainer(
                                padding: EdgeInsets.all(0),
                                blur: 2.2,
                                child: null,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                              ),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Text("Bhagwat Geeta",
                                      style: TextStyle(
                                          fontFamily: "Samarkan",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white))),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Icon(FlutterIcons.quote_left_faw,
                                            size: 20,
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                          verseSanskrit.trim().split("॥")[0] +
                                              "\n॥" +
                                              verseSanskrit
                                                  .trim()
                                                  .split("॥")[1] +
                                              "॥",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "KrutiDev",
                                          ),
                                          textAlign: TextAlign.center),
                                      // SizedBox(height: 5),
                                      Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                              FlutterIcons.quote_right_faw,
                                              size: 20,
                                              color: Colors.white
                                                  .withOpacity(0.6))),
                                      SizedBox(height: 20),
                                      Text(translation.trim(),
                                          maxLines: 8,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontFamily: "Samarkan",
                                              fontSize: 16,
                                              color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(title,
                                      style: TextStyle(
                                          fontFamily: "Samarkan",
                                          fontSize: 12,
                                          color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // if (_imageFile != null)
                      //   Image.file(
                      //     _imageFile,
                      //     // height: 200,
                      //     // width: 200,
                      //   ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              screenshotController
                                  .capture(pixelRatio: 2.5)
                                  .then((File image) {
                                setState(() {
                                  _imageFile = image;
                                });
                              }).catchError((onError) {
                                print(onError);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
