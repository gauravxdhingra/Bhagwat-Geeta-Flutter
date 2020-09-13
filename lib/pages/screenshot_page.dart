import 'dart:io';
import 'dart:typed_data';

import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String lang = "";

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
      lang = args["lang"];

      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  Future<String> saveToDevice() async {
    if (_imageFile == null) {
      await screenshotController.capture(pixelRatio: 2.5).then((File image) {
        setState(() {
          _imageFile = image;
        });
      }).catchError((onError) {
        print(onError);
      });
    }
    Uint8List save = await _imageFile.readAsBytes();
    print(title);
    // var path = await getExternalStorageDirectory();
    // print(path.path);
    // var pathPath = path.path + lang == "eng"
    //     ? "Bhagwat Geeta - $title"
    //     : "Bhagwat Geeta - ${title.replaceAll("अध्याय", "Chapter").replaceAll("श्लोक", "Verse")} - Hindi";
    // print(pathPath);

    // GallerySaver.saveImage(pathPath, albumName: "Shreemad Bhagwat Geeta")
    //     .then((path) {
    //   print(pathPath);
    //   setState(() {
    //     // firstButtonText = 'image saved!';
    //   });
    // });
    print("*************");
    final result = await ImageGallerySaver.saveImage(save,
        quality: 100,
        name: lang == "eng"
            ? "Bhagwat Geeta - $title"
            : "Bhagwat Geeta - ${title.replaceAll("अध्याय", "Chapter").replaceAll("श्लोक", "Verse")} - Hindi");
    print("*************");
    print(result);
    return result;
    // .toString().replaceAll("%20", " ").replaceAll("%2C", ",");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Share",
            style: TextStyle(color: Themes.primaryColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Themes.primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: loading
            ? CircularProgressIndicator()
            : Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.lerp(
                          Alignment.center, Alignment.topCenter, 0.2),
                      child: Screenshot(
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
                    ),
                    // if (_imageFile != null)
                    //   Image.file(
                    //     _imageFile,
                    //     // height: 200,
                    //     // width: 200,
                    //   ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                icon: Icon(Icons.save_alt),
                                color: Themes.primaryColor,
                                iconSize: 35,
                                onPressed: () async {
                                  await saveToDevice();
                                  final SnackBar snackBar = SnackBar(
                                      content: Text("Saved To Gallery"));
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }),
                            IconButton(
                              icon: Icon(Icons.share),
                              color: Themes.primaryColor,
                              iconSize: 33,
                              onPressed: () async {
                                var res = await saveToDevice();
                                print(res);
                                var resDir = Directory.fromUri(Uri.parse(res));
                                // res
                                //     .split("file://")[1]
                                //     .replaceAll("%20", " ")
                                //     .replaceAll("%2C", ",");
                                Share.shareFiles([resDir.path],
                                    text: "Bhagwat Geeta\n" +
                                        title +
                                        "\n\n" +
                                        verseSanskrit.trim() +
                                        "\n\n" +
                                        translation.trim() +
                                        "\n\n Download From Google Play\n url");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
