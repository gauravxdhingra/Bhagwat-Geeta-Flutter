import 'package:bhagwat_geeta/pages/chapter_view_page.dart';
import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
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

  @override
  void didChangeDependencies() async {
    if (!init) {
      String url = "https://bhagavadgita.io";
      // "https://bhagavadgita.io/chapter/1/?page=1";

      final provider = Provider.of<Scraper>(context);
      final document = await provider.getWebpage(url);
      chapters = await provider.getChapters(document);
      // print(provider.getChapterDetails(document));
      // print(provider.getTotalPagesChapter(document).toString());
      // print(provider.getVersesFromPage(document));
      print(chapters);
    }

    setState(() {
      _isLoading = false;
      init = true;
    });
    super.didChangeDependencies();
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
            ? CircularProgressIndicator()
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
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
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text("Go To Chapter and Verse"),
                          ],
                        ),
                        Text("Chapters"),
                        SizedBox(height: 20),
                        for (int i = 0; i < chapters.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ChapterViewPage.routeName,
                                    arguments: {
                                      "chapterHead": chapters.keys.toList()[i],
                                      "chapterMeaning":
                                          chapters[chapters.keys.toList()[i]],
                                      "chapterNumber": i + 1,
                                    });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 170,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.navigate_next,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${i + 1}. ' +
                                              chapters.keys.toList()[i],
                                          style: Themes.homeChapterHead,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          chapters[chapters.keys.toList()[i]],
                                          style: Themes.homeChapterMeaning,
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
