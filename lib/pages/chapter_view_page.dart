import 'package:bhagwat_geeta/theme/theme.dart';
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 3,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                title: Text(
                  chapterHeading,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Container(
                    child: Image.asset("assets/images/cover1.jpg",
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(chapterMeaning),
                  Container(
                    width: double.infinity,
                    child: Text(
                      chapterDetails,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                            height: 150,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  verses[i]["verseNo"],
                                  style: Themes.homeChapterHead,
                                ),
                                Text(
                                  verses[i]["verse"],
                                  style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
