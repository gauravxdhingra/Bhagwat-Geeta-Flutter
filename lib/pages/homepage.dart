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
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Go To Chapter and Verse"),
                    ],
                  ),
                  Text("Chapters"),
                  SizedBox(height: 20),
                  for (int i = 0; i < chapters.length; i++)
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chapters.keys.toList()[i],
                              style: Themes.homeChapterHead,
                            ),
                            Text(
                              chapters[chapters.keys.toList()[i]],
                              style: Themes.homeChapterMeaning,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
