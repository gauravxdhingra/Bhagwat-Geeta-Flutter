import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerseViewPage extends StatefulWidget {
  VerseViewPage({Key key}) : super(key: key);
  static const routeName = "verse_view_page";
  @override
  _VerseViewPageState createState() => _VerseViewPageState();
}

class _VerseViewPageState extends State<VerseViewPage> {
  bool _isLoading = true;
  bool init = false;

  Map<String, String> verse = {};

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;

      final verseUrl = args["verseUrl"];
      final provider = Provider.of<Scraper>(context);

      String url = "https://bhagavadgita.io" + verseUrl;
      print(url);
      final document = await provider.getWebpage(url);
      verse = provider.getFullVerse(document);
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
                children: [
                  Text(verse["title"]),
                  Text(verse["verseSanskrit"]),
                  // TODO IF ENGLISH
                  Text(verse["transliteration"]),
                  Text(verse["wordMeanings"]),
                  Text(verse["translation"]),
                ],
              ),
            ),
    );
  }
}
