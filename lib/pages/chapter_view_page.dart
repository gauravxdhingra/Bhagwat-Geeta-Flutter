import 'package:bhagwat_geeta/pages/verse_view_Page.dart';
import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(chapterNumber.toString() + " " + chapterHeading),
            Text(chapterMeaning),
            Text(chapterDetails),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              for (int i = 0; i < verses.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, VerseViewPage.routeName,
                        arguments: {
                          "verseUrl": verses[i]["url"],
                        });
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Text(verses[i]["verseNo"]),
                        Text(verses[i]["verse"]),
                      ],
                    ),
                  ),
                ),
            if (currentPage < pages)
              FlatButton(
                child: Text("Load More"),
                onPressed: () async {
                  await getNextPage(chapterNumber, currentPage + 1, provider);
                  currentPage += 1;
                },
              ),
          ],
        ),
      ),
    );
  }
}
