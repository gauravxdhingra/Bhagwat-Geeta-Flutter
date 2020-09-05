import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bhagwat_geeta/pages/homepage.dart';
import 'package:bhagwat_geeta/pages/play_audio.dart';
import 'package:blurhash/blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;

import '../provider/scraper.dart';
import '../theme/theme.dart';
import 'verse_view_Page.dart';

class ChapterViewPage extends StatefulWidget {
  ChapterViewPage({Key key}) : super(key: key);
  static const routeName = "chapter_view_page";
  @override
  _ChapterViewPageState createState() => _ChapterViewPageState();
}

class _ChapterViewPageState extends State<ChapterViewPage> {
  bool _isLoading = true;
  bool init = false;

  int chapterNumber = 1;
  int pages = 1;
  int currentPage = 1;

  String chapterHeading = "";
  String chapterMeaning = "";
  String chapterDetails = "";
  int totalVerses;

  Scraper provider;

  ScrollController _controller = ScrollController();

  List<Map<String, String>> verses = [];
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-101.jpg";
  String blurhashString = "LUK1Q^01WCWF_MD%t3WE4;%KV[of";
  Uint8List imageDataBytes;

  Box<Map> hive;
  String url = "";
  var data;
  String language = "";

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      chapterHeading = args["chapterHead"] ?? "";
      chapterMeaning = args["chapterMeaning"] ?? "";
      chapterNumber = args["chapterNumber"];

      provider = Provider.of<Scraper>(context);

      hive = await Hive.openBox<Map>("Geeta");
      var lang = hive.get("lang");
      if (lang == null || lang.toString() == "") {
        hive.put("lang", {"lang": "eng"});
        language = "eng";
      }

      await getChapter();
      await otherInit();
      setState(() {
        _isLoading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  getChapter() async {
    var document;
    url = "https://bhagavadgita.io/chapter/$chapterNumber/?page=";

    if (hive.toMap()["lang"]["lang"] == "eng") {
      language = "eng";
      document = await provider.getWebpage(
          "https://bhagavadgita.io/chapter/$chapterNumber/?page=" + "1");
    } else {
      language = "hi";
      document = await provider.getWebpage(
          "https://bhagavadgita.io/chapter/$chapterNumber/hi/?page=" + "1");
    }
    // document = await provider.getWebpage(url + "1");
    pages = provider.getTotalPagesChapter(document);
    chapterDetails = provider.getChapterDetails(document);
    chapterHeading = document
        .getElementsByClassName("hanuman-gradient-text")[0]
        .getElementsByTagName("h2")[0]
        .text;
    if (hive.toMap()["lang"]["lang"] == "hi")
      chapterHeading = "अध्याय" + chapterHeading.split("Chapter")[1];
    chapterMeaning = document
        .getElementsByClassName("hanuman-gradient-text")[0]
        .getElementsByTagName("h3")[0]
        .text;
    verses = provider.getVersesFromPage(document);

    print(chapterHeading);
  }

  otherInit() async {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    int number = next.call(100, 140);
    if (number == 115 || number == 133) number = 101;
    imageUrl =
        "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-$number.jpg";
    print(imageUrl);

    var x = await Hive.openBox<Map>("Geeta").then((value) => value.toMap());
    blurhashString = x["blurhash"]["$number"];
    print(blurhashString);

    imageDataBytes = await BlurHash.decode(blurhashString, 32, 32);

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        getNextPage(chapterNumber, currentPage + 1, provider);
        currentPage += 1;
      }
    });

    data = JsonDecoder().convert(PickerData);
    totalVerses = data[chapterNumber - 1]['$chapterNumber'].length;
    // print(data[chapterNumber - 1]['$chapterNumber'].length);
  }

  changeLanguage() async {
    setState(() {
      _isLoading = true;
    });
    if (hive.toMap()["lang"]["lang"] == "hi") {
      hive.put("lang", {"lang": "eng"});
      language = "eng";
    } else {
      hive.put("lang", {"lang": "hi"});
      language = "hi";
    }

    await getChapter();
    await otherInit();
    setState(() {
      _isLoading = false;
    });
  }

  showDialogForAudio() async {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("English"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, PlayAudio.routeName,
                          arguments: {
                            "lang": "eng",
                            "chapterNo": chapterNumber,
                            "imgUrl": imageUrl,
                            "blurhash": imageDataBytes,
                          });
                    },
                  ),
                  ListTile(
                    title: Text("Hindi"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, PlayAudio.routeName,
                          arguments: {
                            "lang": "hi",
                            "chapterNo": chapterNumber,
                            "imgUrl": imageUrl,
                            "blurhash": imageDataBytes,
                          });
                    },
                  ),
                  ListTile(
                    title: Text("Sanskrit"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, PlayAudio.routeName,
                          arguments: {
                            "lang": "sans",
                            "chapterNo": chapterNumber,
                            "imgUrl": imageUrl,
                            "blurhash": imageDataBytes,
                          });
                    },
                  ),
                ],
              ),
            ));
  }

  bool isGettingMore = false;

  getNextPage(int chapter, int page, provider) async {
    setState(() {
      isGettingMore = true;
    });
    var document;
    if (hive.toMap()["lang"]["lang"] == "eng") {
      document = await provider
          .getWebpage("https://bhagavadgita.io/chapter/$chapter/?page=$page");
    } else {
      document = await provider.getWebpage(
          "https://bhagavadgita.io/chapter/$chapter/hi/?page=$page");
    }

    verses.addAll(provider.getVersesFromPage(document));
    setState(() {
      isGettingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 125.0,
                  width: 125.0,
                ),
              )
            : CustomScrollView(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                slivers: [
                  buildSliverAppBar(context),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 30, bottom: 0),
                            child: Text(_isLoading ? "" : chapterMeaning,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Themes.primaryColor,
                                    fontFamily:
                                        // language == "hi"
                                        //     ?
                                        // "KrutiDev"
                                        // :
                                        'Samarkan'))),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(_isLoading ? "" : chapterDetails,
                                softWrap: true,
                                style: TextStyle(
                                    fontFamily: language == "hi"
                                        ? "KrutiDev"
                                        : 'Roboto',
                                    fontSize: 15,
                                    wordSpacing: 1.04,
                                    letterSpacing: 0.5))),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: InkWell(
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: InkWell(
                                      onTap: () async {
                                        await showDialogForAudio();
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Themes.primaryColor),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.play_arrow_rounded,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              Text(
                                                  language == "hi"
                                                      ? "ऑडियो चलाएं"
                                                      : "Play Audio",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18)),
                                              SizedBox(width: 5),
                                            ],
                                          )),
                                    ))),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 30, bottom: 0),
                            child: Text(language == "hi" ? "श्लोक" : "Verses",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Themes.primaryColor,
                                    fontFamily: 'Samarkan'))),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, i) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FloatingActionButton(
                                backgroundColor: Themes.primaryColor,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, VerseViewPage.routeName,
                                      arguments: {
                                        "verseUrl": verses[0]["url"].replaceAll(
                                            "verse/1/", "verse/${i + 1}/")
                                      });
                                },
                                heroTag: null,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                      fontSize: 25, fontFamily: "Samarkan"),
                                ),
                              ),
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: totalVerses,
                          ),
                        ),
                        SizedBox(height: 10),
                        for (int i = 0; i < verses.length; i++)
                          buildVerseButtons(context, i),
                        SizedBox(height: 20),
                        if (currentPage < pages)
                          SpinKitThreeBounce(
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          ),
                        if (currentPage < pages) SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            _isLoading ? null : buildFoatingActionButtons(context),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width * 0.85,
      pinned: true,
      centerTitle: true,
      stretch: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.translate),
            onPressed: () async {
              await changeLanguage();
            })
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
            child: Text(_isLoading ? "" : chapterHeading,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Samarkan'))),
        background: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Container(
                child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) =>
                        Image.memory(imageDataBytes,
                            fit: BoxFit.cover, width: double.infinity)))),
      ),
    );
  }

  Padding buildVerseButtons(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, VerseViewPage.routeName,
                arguments: {"verseUrl": verses[i]["url"]});
          },
          child: Container(
            width: double.infinity,
            height: 170,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                Positioned(
                    bottom: -5,
                    right: -12,
                    child: Icon(Icons.navigate_next,
                        color: Colors.white, size: 35)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        hive.toMap()["lang"]["lang"] == "eng"
                            ? verses[i]["verseNo"]
                            : "श्लोक" + verses[i]["verseNo"].split("Verse")[1],
                        style: Themes.homeChapterHead),
                    SizedBox(height: 5),
                    Text(
                      verses[i]["verse"],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: language == "hi" ? 'KrutiDev' : "Samarkan",
                      ),
                      maxLines: 5,
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

  Padding buildFoatingActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (chapterNumber == 1)
              ? FloatingActionButton(
                  heroTag: null,
                  onPressed: null,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.navigate_before, color: Colors.transparent))
              : FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, ChapterViewPage.routeName,
                        arguments: {"chapterNumber": chapterNumber - 1});
                  },
                  backgroundColor: Themes.primaryColor,
                  child: Icon(Icons.navigate_before)),
          (chapterNumber == 18)
              ? FloatingActionButton(
                  heroTag: null,
                  onPressed: null,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.navigate_before, color: Colors.transparent))
              : FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, ChapterViewPage.routeName,
                        arguments: {"chapterNumber": chapterNumber + 1});
                  },
                  backgroundColor: Themes.primaryColor,
                  child: Icon(Icons.navigate_next))
        ],
      ),
    );
  }
}
