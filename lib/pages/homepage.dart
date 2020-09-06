import 'dart:convert';

import 'package:bhagwat_geeta/pages/chapter_view_page.dart';
import 'package:bhagwat_geeta/pages/search_screen.dart';
import 'package:bhagwat_geeta/pages/verse_view_Page.dart';
import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
// with AutomaticKeepAliveClientMixin
{
  bool _isLoading = true;
  bool init = false;

  Map<String, String> chapters = {};
  Box<Map> x;
  String url = "";
  Scraper provider;

  @override
  void didChangeDependencies() async {
    if (!init) {
      provider = Provider.of<Scraper>(context);
      await getData();
      setState(() {
        _isLoading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  var lang;
  String language = "";

  getData() async {
    x = await Hive.openBox<Map>("Geeta");
    lang = x.get("lang");
    if (lang == null || lang.toString() == "") {
      language = "eng";
      x.put("lang", {"lang": "eng"});
    }
    if (x.toMap()["lang"]["lang"] == "eng") {
      language = "eng";
      url = "https://bhagavadgita.io";
    } else {
      language = "hi";
      url = "https://bhagavadgita.io/hi";
    }
    final document = await provider.getWebpage(url);
    chapters = await provider.getChapters(document);
  }

  changeLanguage() async {
    setState(() {
      _isLoading = true;
    });
    if (x.toMap()["lang"]["lang"] == "hi")
      x.put("lang", {"lang": "eng"});
    else
      x.put("lang", {"lang": "hi"});

    await getData();
    setState(() {
      _isLoading = false;
    });
  }

  showPicker() {
    showPickerModal(BuildContext context) {
      Picker(
          adapter: PickerDataAdapter<String>(
              pickerdata: JsonDecoder().convert(PickerData)),
          changeToFirst: true,
          hideHeader: false,
          onConfirm: (Picker picker, List value) {
            print(picker.adapter.text);
            print(picker.adapter.text.split("[")[1].split(",")[0].trim());
            print(picker.adapter.text.split("]")[0].split(",")[1].trim());
            Navigator.pop(context);
            Navigator.pushNamed(context, VerseViewPage.routeName, arguments: {
              "verseUrl":
                  '/chapter/${picker.adapter.text.split("[")[1].split(",")[0].trim()}/verse/${picker.adapter.text.split("]")[0].split(",")[1].trim()}/'
            });
            Navigator.pushNamed(context, VerseViewPage.routeName, arguments: {
              "verseUrl":
                  '/chapter/${picker.adapter.text.split("[")[1].split(",")[0].trim()}/verse/${picker.adapter.text.split("[")[0].split(",")[1].trim()}/'
            });
          },
          confirmText: "Go To",
          confirmTextStyle: TextStyle(color: Themes.primaryColor, fontSize: 20),
          cancelTextStyle: TextStyle(color: Themes.primaryColor, fontSize: 20),
          footer: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(language == "hi" ? 'अध्याय' : "Chapter",
                    style: TextStyle(color: Colors.grey, fontSize: 17)),
                Text(language == "hi" ? 'श्लोक' : "Verse",
                    style: TextStyle(color: Colors.grey, fontSize: 17)),
              ],
            ),
          )).showModal(this.context);
    }

    showPickerModal(context);
  }

  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 11,
              child: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 16 / 11,
                      child: Image.asset("assets/images/drawer.png",
                          fit: BoxFit.cover)),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: double.infinity,
                          child: Text("Bhagwat Geeta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Samarkan",
                                  fontSize: 20))))
                ],
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                await changeLanguage();
              },
              leading: Icon(Icons.translate_rounded),
              title: Text("Change Language"),
              subtitle: Text(language == "hi" ? "Hindi" : "English"),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              },
              leading: Icon(Icons.search),
              title: Text("Search"),
            ),
            ListTile(),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.info),
              title: Text("About Bhagwat Geeta"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.share_rounded),
              title: Text("Share This App"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.star),
              title: Text("Rate Us on Google Play"),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Image.asset(
                'assets/images/loading.gif',
                // height: 125.0,
                width: 125.0,
              ),
            )
          : CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.75,
                  pinned: true,
                  stretch: false,
                  // elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.translate),
                      onPressed: () async {
                        // Navigator.pushNamed(context, SearchScreen.routeName);
                        await changeLanguage();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.pushNamed(context, SearchScreen.routeName);
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    // titlePadding:
                    //     EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    // centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Container(
                      padding: EdgeInsets.symmetric(),
                      decoration: BoxDecoration(
                          // color:
                          //     Theme.of(context).primaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                          language == "hi"
                              ? "श्रीमद्भगवद्गीता"
                              : "Bhagawad Geeta",
                          style: TextStyle(
                              fontFamily:
                                  language == "hi" ? 'KrutiDev' : 'Samarkan',
                              // fontSize: language == "hi" ? 22 : 20,
                              // letterSpacing: 1.1,
                              wordSpacing: 1.2)),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Container(
                        child: Image.asset("assets/images/7.jpg",
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                buildBody(context)
              ],
            ),
    );
  }

  SliverList buildBody(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(height: 40),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(language == "hi" ? "अध्याय" : "Chapters",
                        style: Themes.homeChapterHead.copyWith(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 1.1,
                            fontFamily:
                                language == "hi" ? "KrutiDev" : "Samarkan"))),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: InkWell(
                        onTap: () => showPicker(),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 12),
                            child: Text(
                                language == "hi"
                                    ? 'श्लोक चुनें'
                                    : "Go to Verse",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1.1)))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0),
          Container(
            height: 100,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FloatingActionButton(
                  backgroundColor: Themes.primaryColor,
                  onPressed: () {
                    // print(verses[i]["url"]);
                    Navigator.pushNamed(context, ChapterViewPage.routeName,
                        arguments: {
                          "chapterHead": chapters.keys.toList()[i],
                          "chapterMeaning": chapters[chapters.keys.toList()[i]],
                          "chapterNumber": i + 1,
                        });
                  },
                  heroTag: null,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(fontSize: 25, fontFamily: "Samarkan"),
                  ),
                ),
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 18,
            ),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < chapters.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ChapterViewPage.routeName,
                        arguments: {
                          "chapterHead": chapters.keys.toList()[i],
                          "chapterMeaning": chapters[chapters.keys.toList()[i]],
                          "chapterNumber": i + 1,
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 146,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: -5,
                            right: -10,
                            child: Icon(Icons.navigate_next,
                                color: Colors.white, size: 35)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${i + 1}. ' + chapters.keys.toList()[i],
                                style: Themes.homeChapterHead),
                            SizedBox(height: 10),
                            Text(chapters[chapters.keys.toList()[i]],
                                style: Themes.homeChapterMeaning.copyWith(
                                    fontFamily: language == "hi"
                                        ? 'KrutiDev'
                                        : "Samarkan",
                                    color: Colors.white.withOpacity(0.75))),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // @override
  // bool get wantKeepAlive {
  //   if (language == x.toMap()["lang"]["lang"])
  //     return true;
  //   else
  //     return false;
  // }
}

// [1 47, 2 72, 3 43, 4 42, 5 29, 6 47, 7 30, 8 28, 9 34, 10 42, 11 55, 12 20, 13 35, 27, 20, 24, 28, 78]
const PickerData = '''
[
  {"1": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47"
    ]
  },
  {"2": [
      "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72"
    ]
  },
  {"3": [
      "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43"
    ]
  },
  {"4": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42"
    ]
  },
  {"5": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"
    ]
  },
  {"6": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47"
    ]
  },
  {"7": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"
    ]
  },
  {"8": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"
    ]
  },
  {"9": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34"
    ]
  },
  {"10": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42"
    ]
  },
  {"11": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55"
    ]
  },
  {"12": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
  },
  {"13": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35"
    ]
  },
  {"14": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"
    ]
  },
   { "15": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"
    ]
  },
  {"16": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"
    ]
  },
  {"17": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"
    ]
  },
  {"18": [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78"
    ]
  }
]''';
