import 'package:bhagwat_geeta/provider/scraper.dart';
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
      String url = "https://bhagavadgita.io/chapter/1/?page=1";
      //  "https://bhagavadgita.io";
      final provider = Provider.of<Scraper>(context);
      final document = await provider.getWebpage(url);
      // chapters = await provider.getChapters(document);
      // print(provider.getChapterDetails(document));
      // print(provider.getTotalPagesChapter(document).toString());
      // print(chapters);
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
      body: Container(
          // TODO Go To Chapter and Verse
          // TODO Language
          ),
    );
  }
}
