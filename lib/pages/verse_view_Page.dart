import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bhagwat_geeta/pages/screenshot_page.dart';
import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:blurhash/blurhash.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// import 'package:image/image.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:math';

import 'homepage.dart';

class VerseViewPage extends StatefulWidget {
  VerseViewPage({Key key}) : super(key: key);
  static const routeName = "verse_view_page";
  @override
  _VerseViewPageState createState() => _VerseViewPageState();
}

class _VerseViewPageState extends State<VerseViewPage> {
  Uint8List imageDataBytes;
  bool _isLoading = true;
  bool init = false;
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-101.jpg";
  String blurhashString = "LUK1Q^01WCWF_MD%t3WE4;%KV[of";
  String verseUrl = "";
  var data;
  Map<String, String> verse = {};
  int chapterNo;
  int verseNo;
  Box<Map> hive;
  File image;
  // double _progress = 0.0;
  bool isFav = false;
  Scraper provider;

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      verseUrl = args["verseUrl"];
      provider = Provider.of<Scraper>(context);
      data = JsonDecoder().convert(PickerData);
      chapterNo = int.parse(verseUrl.split("/chapter/")[1].split("/")[0]);
      verseNo = int.parse(verseUrl.split("/verse/")[1].split("/")[0]);
      hive = await Hive.openBox<Map>("Geeta");

      await getVerse();
      await getImage();
      setState(() {
        _isLoading = false;
        init = true;
      });
    }

    super.didChangeDependencies();
  }

  getImage() async {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    int number = next.call(100, 140);
    if (number == 115 || number == 133) number = 101;
    imageUrl =
        "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-$number.jpg";

    var x = hive.toMap();
    blurhashString = x["blurhash"]["$number"];
    imageDataBytes = await BlurHash.decode(blurhashString, 32, 32);

    isFav = hive.toMap()["fav"].containsKey(verseUrl);
    print(hive.toMap()["fav"]);
    print(verse);
    // ImageDownloader.callback(
    //     onProgressUpdate: (String imageId, int progress) {
    //   setState(() {
    //     _progress = progress * 0.01;
    //     print(_progress);
    //   });
    // });
  }

  getVerse() async {
    String url = "https://bhagavadgita.io" + verseUrl;
    if (hive.toMap()["lang"]["lang"] == "eng") {
      url = "https://bhagavadgita.io" + verseUrl;
      print(url);
      final document = await provider.getWebpage(url);
      verse = provider.getFullVerse(document, eng: true);
    } else {
      url = "https://bhagavadgita.io" + verseUrl + "hi/";
      print(url);
      final document = await provider.getWebpage(url);
      verse = provider.getFullVerse(document, eng: false);
    }
  }

  var x;
  String language = "";
  changeLang() async {
    setState(() {
      _isLoading = true;
    });
    x = await Hive.openBox<Map>("Geeta");
    if (x.toMap()["lang"]["lang"] == "eng") {
      x.put("lang", {"lang": "hi"});
      language = "hi";
      await getVerse();
    } else {
      x.put("lang", {"lang": "eng"});
      language = "eng";
      await getVerse();
    }
    setState(() {
      _isLoading = false;
    });
  }

  passImage() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Text("Loading...")
                      ]))),
            ));

    String fileName = imageUrl.split("gita-")[1].split(".")[0] + ".jpg";

    try {
      var imageId = await ImageDownloader.downloadImage(imageUrl,
          destination: AndroidDestinationType.custom(directory: "")
            ..inExternalFilesDir()
            ..subDirectory(fileName));
      print(imageId);
      if (imageId == null) {
        return;
      }
      var path = await ImageDownloader.findPath(imageId);
      image = File(path);
    } on PlatformException catch (error) {
      print(error);
    }
    Navigator.pushReplacementNamed(context, ScreenshotScreen.routeName,
        arguments: {
          "image": image,
          "verseSanskrit": verse["verseSanskrit"],
          "translation": verse["translation"],
          "title": verse["title"],
          "lang": hive.toMap()["lang"]["lang"]
        });
  }

  addToFav() async {
    await hive.put("fav", {
      verseUrl: {"verse": verse}
    });
    print(verseUrl);
    isFav = true;
    setState(() {});
  }

  removeFromFav() async {
    Map temp = hive.get("fav");
    temp.remove(verseUrl);
    print(temp);
    hive.put("fav", temp);
    isFav = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif', width: 125.0))
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [buildSliverAppBar(context), buildSliverBody(context)],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isLoading
            ? null
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (verseUrl.split("/verse/")[1].split("/")[0] == "1")
                        ? FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.navigate_before,
                                color: Colors.transparent))
                        : FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, VerseViewPage.routeName, arguments: {
                                "verseUrl":
                                    "/chapter/$chapterNo/verse/${verseNo - 1}/"
                              });
                            },
                            backgroundColor: Themes.primaryColor,
                            child: Icon(Icons.navigate_before)),
                    (verseNo == data[chapterNo - 1]['$chapterNo'].length)
                        ? FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.navigate_before,
                                color: Colors.transparent))
                        : FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, VerseViewPage.routeName, arguments: {
                                "verseUrl":
                                    "/chapter/$chapterNo/verse/${verseNo + 1}/"
                              });
                            },
                            backgroundColor: Themes.primaryColor,
                            child: Icon(Icons.navigate_next))
                  ],
                ),
              ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width * 0.85,
      pinned: true,
      centerTitle: true,
      stretch: true,
      actions: [
        IconButton(
          icon: Icon(Icons.translate),
          onPressed: () async {
            await changeLang();
          },
        ),
        IconButton(
          icon: isFav == null || isFav == false
              ? Icon(Icons.favorite_border)
              : Icon(Icons.favorite),
          onPressed: isFav == null || isFav == false
              ? () async {
                  await addToFav();
                }
              : () async {
                  await removeFromFav();
                },
        ),
        IconButton(
          icon: Icon(FlutterIcons.share_2_fea),
          onPressed: () async {
            await passImage();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        centerTitle: false,
        collapseMode: CollapseMode.parallax,
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4)),
            child: Text(verse["title"],
                style: TextStyle(fontFamily: 'Samarkan'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center)),
        background: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Container(
                child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, String url) => Image.memory(
                  imageDataBytes,
                  fit: BoxFit.cover,
                  width: double.infinity),
            ))),
      ),
    );
  }

  SliverPadding buildSliverBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Icon(FlutterIcons.quote_left_faw,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 25),
          Text(verse["verseSanskrit"],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Samarkan'),
              textAlign: TextAlign.center),

          Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Icon(FlutterIcons.quote_right_faw,
                  color: Theme.of(context).primaryColor)),
          // TODO IF ENGLISH

          if (hive.toMap()["lang"]["lang"] == "eng") SizedBox(height: 20),
          if (hive.toMap()["lang"]["lang"] == "eng")
            buildTitle("Transliteration"),
          SizedBox(height: 10),
          if (hive.toMap()["lang"]["lang"] == "eng")
            Text(verse["transliteration"],
                style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),

// —
          SizedBox(height: 20),
          //  शब्दार्थ   word meanings
          // अनुवाद   translation
          buildTitle(
              hive.toMap()["lang"]["lang"] == "eng" ? "Translation" : "अनुवाद"),
          SizedBox(height: 10),
          Text(verse["translation"],
              style: TextStyle(fontSize: 17), textAlign: TextAlign.center),

          SizedBox(height: 50),
          buildTitle(hive.toMap()["lang"]["lang"] == "eng"
              ? "Word Meanings"
              : "शब्दार्थ"),
          SizedBox(height: 15),
          for (int i = 0; i < verse["wordMeanings"].split("; ").length; i++)
            Column(
              children: [
                Text(
                    verse["wordMeanings"].split("; ")[i].replaceAll("—", " — "),
                    style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
                SizedBox(height: 7),
              ],
            ),
          SizedBox(height: 90),
        ]),
      ),
    );
  }

  Container buildTitle(text) => Container(
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Samarkan")),
            ),
          ),
        ),
      );
}

// BLURHASH
// Future<String> blurHashEncode(i) async {
//   Uint8List fileData =
//       await (rootBundle.load("assets/images/GeetaImages/$i.jpg"))
//           .then((value) => value.buffer.asUint8List());
//   img.Image image = img.decodeImage(fileData.toList());

//   final blurHash = encodeBlurHash(
//     image.getBytes(format: Format.rgba),
//     image.width,
//     image.height,
//   );

//   print("$blurHash");
//   return blurHash;
// }

// for (int i = 100; i <= 114; i++) {
//   print('$i\n');
//   await blurHashEncode(i);
// }
// for (int i = 116; i <= 132; i++) {
//   print('$i\n');
//   await blurHashEncode(i);
// }
// for (int i = 134; i <= 140; i++) {
//   print('$i\n');
//   await blurHashEncode(i);
// }
