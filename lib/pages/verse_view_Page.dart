import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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

      // var yt = YoutubeExplode();
      // var video =
      //     await yt.videos.get('https://www.youtube.com/watch?v=bo_efYhYU2A');

      // print('Title: ${video.title}');

      // // var yt = YoutubeExplode();

      // var manifest = await yt.videos.streamsClient.getManifest('bnsUkE8i0tU');
      // // var streamInfo = streamManifest.audioOnly.withHigestBitrate();
      // print(manifest.audio.last.url);
      // print(streamInfo);

      // yt.close();
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
      appBar: _isLoading
          ? AppBar()
          : AppBar(
              title: Text(verse["title"],
                  style: TextStyle(fontFamily: 'Samarkan')),
            ),
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text(verse["verseSanskrit"],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Samarkan'),
                      textAlign: TextAlign.center),
                  // TODO IF ENGLISH
                  Text(verse["transliteration"],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                  Text(verse["wordMeanings"],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                  Text(verse["translation"],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
    );
  }
}
