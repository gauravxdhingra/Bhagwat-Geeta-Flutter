import 'dart:io';
import 'dart:typed_data';

import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:blurhash/blurhash.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
// import 'package:image/image.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:math';

class VerseViewPage extends StatefulWidget {
  VerseViewPage({Key key}) : super(key: key);
  static const routeName = "verse_view_page";
  @override
  _VerseViewPageState createState() => _VerseViewPageState();
}

class _VerseViewPageState extends State<VerseViewPage> {
  Uint8List imageDataBytes;
  bool _isLoading = true;
  bool init = false;
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-101.jpg";
  String blurhashString = "LUK1Q^01WCWF_MD%t3WE4;%KV[of";

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
      if (number == 115 || number == 133) number = 101;
      imageUrl =
          "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-$number.jpg";
      print(imageUrl);

      var x = await Hive.openBox<Map>("Geeta").then((value) => value.toMap());
      blurhashString = x["blurhash"]["$number"];
      print(blurhashString);

      imageDataBytes = await BlurHash.decode(blurhashString, 32, 32);

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

// BLURHASH
      // Future<String> blurHashEncode(i) async {
      //   Uint8List fileData =
      //       await (rootBundle.load("assets/images/GeetaImages/$i.jpg"))
      //           .then((value) => value.buffer.asUint8List());
      //   img.Image image = img.decodeImage(fileData.toList());

      //   final blurHash = encodeBlurHash(
      //     image.getBytes(format: Format.rgba),
      //     image.width,
      //     image.height,
      //   );

      //   print("$blurHash");
      //   return blurHash;
      // }

      // for (int i = 100; i <= 114; i++) {
      //   print('$i\n');
      //   await blurHashEncode(i);
      // }
      // for (int i = 116; i <= 132; i++) {
      //   print('$i\n');
      //   await blurHashEncode(i);
      // }
      // for (int i = 134; i <= 140; i++) {
      //   print('$i\n');
      //   await blurHashEncode(i);
      // }
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
                slivers: [buildSliverAppBar(context), buildSliverBody(context)],
              ),
      ),
    );
  }

  SliverPadding buildSliverBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Icon(FlutterIcons.quote_left_faw,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 25),
          Text(verse["verseSanskrit"],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Samarkan'),
              textAlign: TextAlign.center),

          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Icon(FlutterIcons.quote_right_faw,
                color: Theme.of(context).primaryColor),
          ),
          // TODO IF ENGLISH

          SizedBox(height: 20),
          buildTitle("Transliteration"), SizedBox(height: 10),
          Text(verse["transliteration"],
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),

// —
          SizedBox(height: 30),
          buildTitle("Translation"), SizedBox(height: 10),
          Text(verse["translation"],
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center),

          SizedBox(height: 50),
          buildTitle("Word Meanings"), SizedBox(height: 15),
          for (int i = 0; i < verse["wordMeanings"].split("; ").length; i++)
            Column(
              children: [
                Text(
                    verse["wordMeanings"].split("; ")[i].replaceAll("—", " — "),
                    style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
                SizedBox(height: 9),
              ],
            ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }

  Container buildTitle(text) => Container(
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontFamily: "Samarkan"),
            ),
          ),
        ),
      );

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      pinned: true,
      centerTitle: true,
      stretch: true,
      actions: [
        // IconButton(
        //   icon: Icon(FlutterIcons.share_2_fea),
        //   onPressed: () {},
        // )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        centerTitle: false,
        collapseMode: CollapseMode.parallax,
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4)),
            child: Text(verse["title"],
                style: TextStyle(fontFamily: 'Samarkan'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center)),
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
