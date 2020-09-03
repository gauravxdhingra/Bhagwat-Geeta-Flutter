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

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  bool init = false;

  Map<String, String> chapters = {};
  Box<Map> x;
  String url = "";
  Scraper provider;

  @override
  void didChangeDependencies() async {
    if (!init) {
      await getData();
      setState(() {
        _isLoading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  // "https://bhagavadgita.io/chapter/1/?page=1";
  getData() async {
    provider = Provider.of<Scraper>(context);
    x = await Hive.openBox<Map>("Geeta");
    var lang = x.get("lang");
    if (lang == null || lang.toString() == "") {
      x.put("lang", {"lang": "eng"});
    }
    if (x.toMap()["lang"]["lang"] == "eng")
      url = "https://bhagavadgita.io";
    else
      url = "https://bhagavadgita.io/hi";

    final document = await provider.getWebpage(url);
    chapters = await provider.getChapters(document);
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
          footer: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Chapter", style: TextStyle()),
                Text("Verse"),
              ],
            ),
          )).showModal(this.context);
    }

    showPickerModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
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
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    stretch: true,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.translate),
                        onPressed: () {
                          Navigator.pushNamed(context, SearchScreen.routeName);
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
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      centerTitle: false,
                      collapseMode: CollapseMode.parallax,
                      title: Text(
                        "Bhagawad Geeta",
                        style: TextStyle(fontFamily: 'Samarkan', fontSize: 22),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Container(
                          child: Image.asset(
                            "assets/images/7.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildBody(context)
                ],
              ),
      ),
    );
  }

  SliverList buildBody(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: InkWell(
                onTap: () => showPicker(),
                child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Go To Chapter and Verse",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center))),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("Chapters",
                style: Themes.homeChapterHead
                    .copyWith(color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center),
          ),
          SizedBox(height: 8),
          for (int i = 0; i < chapters.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  height: 170,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          right: 0,
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
                                  color: Colors.white.withOpacity(0.75))),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: 70),
        ],
      ),
    );
  }
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
