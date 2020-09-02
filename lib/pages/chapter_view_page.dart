import 'dart:math';
import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;

import '../provider/scraper.dart';
import '../theme/theme.dart';
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

  ScrollController _controller = ScrollController();

  List<Map<String, String>> verses = [];
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-101.jpg";
  String blurhashString = "LUK1Q^01WCWF_MD%t3WE4;%KV[of";
  Uint8List imageDataBytes;

  @override
  void didChangeDependencies() async {
    if (!init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      chapterHeading = args["chapterHead"] ?? "";
      chapterMeaning = args["chapterMeaning"] ?? "";
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

      var x = await Hive.openBox<Map>("Geeta").then((value) => value.toMap());
      blurhashString = x["blurhash"]["$number"];
      print(blurhashString);

      imageDataBytes = await BlurHash.decode(blurhashString, 32, 32);

      _controller.addListener(() {
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          getNextPage(chapterNumber, currentPage + 1, provider);
          currentPage += 1;
        }
      });

// TODO GET AUDIO STREAM
      // var yt = yte.YoutubeExplode();
      // var manifest = await yt.videos.streamsClient.getManifest('16yApGx6NEs');
      // print(manifest.audioOnly.last.url);
      // yt.close();

      // var video =
      //     await yt.videos.get('https://www.youtube.com/watch?v=16yApGx6NEs');
      // print('Title: ${video.title}');
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
            ? Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 125.0,
                  width: 125.0,
                ),
              )
            : CustomScrollView(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                slivers: [
                  buildSliverAppBar(context),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 30, bottom: 0),
                            child: Text(_isLoading ? "" : chapterMeaning,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Themes.primaryColor,
                                    fontFamily: 'Samarkan'))),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(_isLoading ? "" : chapterDetails,
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 15))),
                        SizedBox(height: 30),
                        if (_isLoading) CircularProgressIndicator(),
                        if (!_isLoading)
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 0, bottom: 15),
                              child: Text(_isLoading ? "" : "Verses",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Themes.primaryColor,
                                      fontFamily: 'Samarkan'))),
                        if (!_isLoading)
                          for (int i = 0; i < verses.length; i++)
                            buildVerseButtons(context, i),
                        SizedBox(height: 20),
                        if (currentPage < pages)
                          SpinKitThreeBounce(
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          ),
                        if (currentPage < pages) SizedBox(height: 20),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isLoading
            ? null
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (chapterNumber == 1)
                        ? FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.navigate_before,
                                color: Colors.transparent))
                        : FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, ChapterViewPage.routeName,
                                  arguments: {
                                    "chapterNumber": chapterNumber - 1
                                  });
                            },
                            backgroundColor: Themes.primaryColor,
                            child: Icon(Icons.navigate_before)),
                    (chapterNumber == 18)
                        ? FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.navigate_before,
                                color: Colors.transparent))
                        : FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, ChapterViewPage.routeName,
                                  arguments: {
                                    "chapterNumber": chapterNumber + 1
                                  });
                            },
                            backgroundColor: Themes.primaryColor,
                            child: Icon(Icons.navigate_next))
                  ],
                ),
              ),
      ),
    );
  }

  Padding buildVerseButtons(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, VerseViewPage.routeName, arguments: {
            "verseUrl": verses[i]["url"],
          });
        },
        child: Container(
          width: double.infinity,
          height: 170,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  right: 0,
                  child:
                      Icon(Icons.navigate_next, color: Colors.white, size: 35)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(verses[i]["verseNo"], style: Themes.homeChapterHead),
                  Text(
                    verses[i]["verse"],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      pinned: true,
      centerTitle: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        centerTitle: false,
        collapseMode: CollapseMode.parallax,
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4)),
            child: Text(_isLoading ? "" : chapterHeading,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Samarkan'))),
        background: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Container(
                child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, String url) => Image.memory(
                  imageDataBytes,
                  fit: BoxFit.cover,
                  width: double.infinity),
            ))),
      ),
    );
  }
}
