import 'dart:math';

import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/scraper.dart';
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

  Scraper provider;

  List<Map<String, String>> verses = [];
  String imageUrl = "";

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      chapterHeading = args["chapterHead"];
      chapterMeaning = args["chapterMeaning"];
      chapterNumber = args["chapterNumber"];

      provider = Provider.of<Scraper>(context);

      String url = "https://bhagavadgita.io/chapter/$chapterNumber/?page=";
      final document = await provider.getWebpage(url + "1");
      pages = provider.getTotalPagesChapter(document);
      chapterDetails = provider.getChapterDetails(document);
      chapterHeading = document
          .getElementsByClassName("hanuman-gradient-text")[0]
          .getElementsByTagName("h2")[0]
          .text;
      chapterMeaning = document
          .getElementsByClassName("hanuman-gradient-text")[0]
          .getElementsByTagName("h3")[0]
          .text;
      verses = provider.getVersesFromPage(document);

      final _random = new Random();
      int next(int min, int max) => min + _random.nextInt(max - min);
      int number = next.call(100, 140);
      imageUrl =
          "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-$number.jpg";
      print(imageUrl);

      setState(() {
        _isLoading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  bool isGettingMore = false;

  getNextPage(int chapter, int page, provider) async {
    setState(() {
      isGettingMore = true;
    });
    String url = "https://bhagavadgita.io/chapter/$chapter/?page=$page";
    final document = await provider.getWebpage(url);

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
            ? CircularProgressIndicator()
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    centerTitle: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      centerTitle: false,
                      collapseMode: CollapseMode.parallax,
                      title: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          _isLoading ? "" : chapterHeading,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Samarkan'),
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Container(
                            child: CachedNetworkImage(
                                imageUrl: imageUrl, fit: BoxFit.cover)
                            //  Image.asset("assets/images/cover1.jpg",
                            //     fit: BoxFit.cover),
                            ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 25, bottom: 15),
                          child: Text(
                            _isLoading ? "" : chapterMeaning,
                            style: TextStyle(
                                fontSize: 20, color: Themes.primaryColor),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            _isLoading ? "" : chapterDetails,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_isLoading) CircularProgressIndicator(),
                        if (!_isLoading)
                          for (int i = 0; i < verses.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, VerseViewPage.routeName,
                                      arguments: {
                                        "verseUrl": verses[i]["url"],
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
                                        children: [
                                          Text(
                                            verses[i]["verseNo"],
                                            style: Themes.homeChapterHead,
                                          ),
                                          Text(
                                            verses[i]["verse"],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        if (currentPage < pages)
                          FlatButton(
                            child: Text("Load More"),
                            onPressed: () async {
                              await getNextPage(
                                  chapterNumber, currentPage + 1, provider);
                              currentPage += 1;
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
        // floatingActionButton: chapterNumber < 18
        //     ? FloatingActionButton.extended(
        //         label: Text("Next Chapter"),
        //         onPressed: () {},
        //         backgroundColor: Colors.red[700],
        //         icon: Icon(Icons.navigate_next),
        //         // Themes.primaryColor,
        //       )
        // : null,
      ),
    );
  }
}
