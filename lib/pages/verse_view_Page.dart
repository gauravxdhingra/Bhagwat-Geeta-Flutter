import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:math';

class VerseViewPage extends StatefulWidget {
  VerseViewPage({Key key}) : super(key: key);
  static const routeName = "verse_view_page";
  @override
  _VerseViewPageState createState() => _VerseViewPageState();
}

class _VerseViewPageState extends State<VerseViewPage> {
  bool _isLoading = true;
  bool init = false;
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-140.jpg";

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

      final _random = new Random();
      int next(int min, int max) => min + _random.nextInt(max - min);
      int number = next.call(100, 140);
      imageUrl =
          "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-$number.jpg";
      print(imageUrl);
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
                      title: Text(verse["title"],
                          style: TextStyle(fontFamily: 'Samarkan'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center),
                      background: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          child: Container(
                              child: CachedNetworkImage(imageUrl: imageUrl))),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Icon(FlutterIcons.quote_right_faw),
                      Text(verse["verseSanskrit"],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Samarkan'),
                          textAlign: TextAlign.center),
                      // TODO IF ENGLISH

                      Text('Transliteration'),
                      Text(verse["transliteration"],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),

                      Text("Word Meanings"),
                      Text(verse["wordMeanings"],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),

                      Text("Translation"),
                      Text(verse["translation"],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                    ]),
                  )
                ],
              ),
      ),
    );
  }
}
