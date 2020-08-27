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
import 'package:image/image.dart';
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
  bool _isLoading = true;
  bool init = false;
  String imageUrl =
      "https://www.bhagavad-gita.us/wp-content/uploads/2012/09/gita-101.jpg";

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

      // var x = await Hive.openBox<Map>("Blurhash");

      // Map blurhash = {
      //   "100": "LeI}LV~nE3IB?a%MRkoHNaafRkkC",
      //   "101": "LUK1Q^01WCWF_MD%t3WE4;%KV[of",
      //   "102": "LaFiPiR%4ot8~pfkIAs:t8ofj?ae",
      //   "103": "LUKwag-n0Mf,b{t6xUs.9HbcxtoJ",
      //   "104": "LKLp?3ITMyxG_NNMM{NH4px]M|WA",
      //   "105": "LWPFMwEzL#WXyXWCMxR*VYWqEMs+",
      //   "106": "LND+h*WF0MIpS4s.M{oM0MxX%LbH",
      //   "107": "LDJtq.uP^bD+_4%KIooID\$I9NGRi",
      //   "108": "L;K^mKM~M{bb_NWEe-aztmt6ofae",
      //   "109": "LOGut85vMe%K_LH@VEs+B?o}ogM|",
      //   "110": "LSKJ-vbE02jvt8jsfRe:IWa#bbjY",
      //   "111": "LRH_G8_20M9G~q?bIUROtTo}M{nh",
      //   "112": "LDGR6TDkDj?G0g9c%ftP9]xsR+9I",
      //   "113": "LYJQ_oV?8|oI_4RPjDa\$T1ocobjZ",
      //   "114": "LKGkzL0L02?a*0ROIUxv4;t7xtRj",
      //   "116": "LDKA+v?cRoxw=dj]s+Rk03RiR%Rj",
      //   "117": "LQIh53s70MtT%js+NGo#D*W?NGoI",
      //   "118": "LTIqx~RONHIpyGWraJoI0MWXV?t6",
      //   "119": "LCFYJJ0g0QV{%}H[%gS}75Dj^%x[",
      //   "120": "LDAwPPZit,In%O%hROaK0KtlQ,s:",
      //   "121": "LxJa=*%MR%Ny%jxun~kDE1Rjs:WX",
      //   "122": "LZLMt:.8IBRQ~XtSM{ozBDX9nNIq",
      //   "123": "LED9%]EMEL.70h%fwhRj9urZSLRk",
      //   "124": "LgHLedS~\$QJ60gr?NZjYJ6WURks:",
      //   "125": "LMDJ,wxa0hM|70kC\$hk95oRk+_t7",
      //   "126": "LoHndGI.Isf,.TsSRnNyTesQWCkD",
      //   "127": "LEH,-equ57ERE.xoKiFf16+[bvcE",
      //   "128": "LKGRO@\${0NE39_t7f5V=Rj9wNK-P",
      //   "129": "LCHw_RQT9HE2t,~AICM{0#xur@x[",
      //   "130": "LJL4H6-919Nv?ax_-nM~0OaJMyt3",
      //   "131": "LGL{;J0L59=^ctIUNeozypIqWrRj",
      //   "132": "LHKdeJ-90i\$%BaN1IYW=75N#N0xU",
      //   "134": "LIK0+omm01%3t-XUE3adR.V_\${tQ",
      //   "135": "LXMr;vOrh}ov};W=#mWU9aaftQjZ",
      //   "136": "LBL4A-%P7Op05_kD%4jK5SRiM|s:",
      //   "137": "LFL{qv},M%IX5PjDX3x]9IskaKNa",
      //   "138": "LEK-8MNO0OR#jZe=M}b0Dl%fIVs8",
      //   "139": "LLKKQM?caJI9%%o#V?aeJ=IUNIt7",
      //   "140": "LQL377kV0%soNgnixaWV9[flw]js"
      // };

      // x.put("blurhash", blurhash);
      // print(x.toMap());

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
          Text('Transliteration'),
          Text(verse["transliteration"],
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),

// —
          SizedBox(height: 20),
          Text("Translation"),
          Text(verse["translation"],
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center),

          SizedBox(height: 40),
          Text("Word Meanings"),
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
          SizedBox(height: 100),
        ]),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3,
      pinned: true,
      centerTitle: true,
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
                child:
                    CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover))),
      ),
    );
  }
}
