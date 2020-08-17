import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChapterViewWidget extends StatefulWidget {
  ChapterViewWidget({Key key}) : super(key: key);

  @override
  _ChapterViewWidgetState createState() => _ChapterViewWidgetState();
}

class _ChapterViewWidgetState extends State<ChapterViewWidget> {
  bool _isLoading = true;
  bool init = false;

  int pages = 1;
  String chapterDetails = "";
  List<Map<String, String>> verses = [];

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;

      final provider = Provider.of<Scraper>(context);

      String url = "https://bhagavadgita.io/chapter/1/?page=";
      final document = await provider.getWebpage(url + "1");
      pages = provider.getTotalPagesChapter(document);
      chapterDetails = provider.getChapterDetails(document);
      verses = provider.getVersesFromPage(document);
    }

    super.didChangeDependencies();
  }

  getNextPage(int i, provider) async {
    String url = "https://bhagavadgita.io/chapter/1/?page=";
    final document = await provider.getWebpage(url + '$i');
    verses = provider.getVersesFromPage(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Chapter Number + Chapter Name"),
            Text("Chapter Desc"),
            for (int i = 0; i < verses.length; i++)
              InkWell(
                onTap: () {
                  // verses[i]["url"]
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
          ],
        ),
      ),
    );
  }
}
