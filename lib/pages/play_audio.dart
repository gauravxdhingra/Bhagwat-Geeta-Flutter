import 'package:flutter/material.dart';
// import 'package:flutter_exoplayer/audio_notification.dart';
// import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;

class PlayAudio extends StatefulWidget {
  PlayAudio({Key key}) : super(key: key);
  static const routeName = "play_audio";
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  bool init = false;
  bool loading = true;
  int chapterNo;

  String lang;
  String language;
  String url = "";
  AudioPlayer audioPlayer;
  var _lowerValue;
  var _upperValue;
  // Result audio;
  AudioPlayer player;
  var x;
  Duration duration;

  @override
  void didChangeDependencies() async {
    if (!init) {
      var args = ModalRoute.of(context).settings.arguments as Map;
      lang = args["lang"];
      chapterNo = args["chapterNo"];
      if (lang == "eng") {
        language = "English";
        url = engList[chapterNo - 1];
      } else if (lang == "hi") {
        language = "Hindi";
        url = hiList[chapterNo - 1];
      } else if (lang == "sans") {
        language = "Sanskrit";
        url = sansList[chapterNo - 1];
      }

      if (_lowerValue == null) _lowerValue = 0.0;
      if (_upperValue == null) _upperValue = 0.0;

      var yt = yte.YoutubeExplode();
      var manifest = await yt.videos.streamsClient.getManifest(url);
      String streamUrl = manifest.audioOnly.last.url.toString();
      yt.close();

      player = AudioPlayer();

      try {
        duration = await player.setUrl(streamUrl);
      } catch (e) {
        print(e);
      }
      // String streamUrl =
      //     "https://r5---sn-qxaeen7l.googlevideo.com/videoplayback?expire=1599126875&ei=-2hQX7H0Dsimz7sPmdibuAI&ip=110.172.189.51&id=o-APDZorRMvv0f2naSBJhfy3EURyko8bCDfYwctxdmfMVR&itag=251&source=youtube&requiressl=yes&mh=Wa&mm=31,26&mn=sn-qxaeen7l,sn-cvh76nes&ms=au,onr&mv=m&mvi=5&pl=24&initcwndbps=507500&vprv=1&mime=audio/webm&gir=yes&clen=105539586&dur=6459.781&lmt=1577276482176105&mt=1599105163&fvip=5&keepalive=yes&c=WEB&txp=1301222&sparams=expire,ei,ip,id,itag,source,requiressl,vprv,mime,gir,clen,dur,lmt&sig=AOq0QJ8wRQIgPh1da00AuBMY2DA4XeSkC3SDvYo56Q1b7Ni4h22i6MwCIQDsZtaGwlcmJA8o3bRkUFS25tqXqz7vv1viba-uNTUaeg==&lsparams=mh,mm,mn,ms,mv,mvi,pl,initcwndbps&lsig=AG3C_xAwRAIgEC2Dj4yP-wOymJpi67VNycZMMbsONrm36OfzuWQqGg8CIDN9UX-LouDJ08z98OeMOwDzMp4PgAmxk38lKV17dl-9";

      print(duration);

      player.play();
      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  List hiList = [
    "B6uV7enE8Ek",
    "3Dygl8-1Mm0",
    "ZWqUYD3NXTM",
    "5yWJTNicjfk",
    "CvhxVDiOBEA",
    "jMquMUqE80c",
    "1twYXeS1pvo",
    "q-1SwulnKY8",
    "2TEOA3uX5MA",
    "bkDFat8cxg8",
    "saIOU90rG9E",
    "ng9igotmFvs",
    "JsQP2WJwOKE",
    "mVVQkb8t8zo",
    "_TjdOXgDp-4",
    "Cgvx--lhKxA",
    "W20fcNzYOu0",
    "i3i5vbiPc2I"
  ];

  List engList = [
    "t73uLIgRvjk",
    "IjTXzH0Otgw",
    "uF2u6ceEzlE",
    "IXyD440L5H8",
    "s0wrprqFtdE",
    "XUq3Y6KWO7w",
    "nbQv7aEFAYo",
    "caiiELOaRRw",
    "bzrX_-NhmYI",
    "0odzBKQac3w",
    "hxGm592vse0",
    "YDqgrJfgMuM",
    "uR-olEdoBqg",
    "466GiSlGqKo",
    "YdOyrfPzmFY",
    "8LHbWG9xkco",
    "TChDXoRE2OM",
    "bj8h4qxB7Qg",
    "JXCBzQlNTVw"
  ];

  List sansList = [
    "16yApGx6NEs",
    "WuZqx82rsos",
    "e3-oIBpyVu0",
    "0VKXmlBft-E",
    "6btGhE7_7-E",
    "zc_4CcKipFs",
    "abYKS195DME",
    "mMBdptd-p4w",
    "HY2N3rr9mB0",
    "764uwNhcVmA",
    "B1ChG0dmUrc",
    "R4xZXNZbD10",
    "dlsx_6q4kSQ",
    "JAvU5rElSK0",
    "CUu_iNRhxGM",
    "rSs9oUPJSJQ",
    "zqjEQUg04Xg",
    "YyRX0veGjnc",
  ];

  @override
  Widget build(BuildContext context) {
    print(player.position.inSeconds.toString());
    return SafeArea(
        child: Scaffold(
      body: loading
          ? CircularProgressIndicator()
          : Container(
              child: Column(
                children: [
                  Container(),
                  Text("Chapter $chapterNo - $language"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () async {
                          player.play();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () async {
                          player.pause();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.speaker),
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  FlutterSlider(
                    values: [_lowerValue],
                    max: duration.inSeconds.toDouble(),
                    min: 0,
                    onDragCompleted:
                        (handlerIndex, lowerValue, upperValue) async {
                      _lowerValue = lowerValue;
                      _upperValue = upperValue;
                      print(lowerValue);
                      print(x);
                      // print(upperValue);
                      await player.seek(Duration(seconds: lowerValue.round()));
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${player.position.inSeconds}'),
                      Text(player.duration.inSeconds.toString()),
                    ],
                  ),
                ],
              ),
            ),
    ));
  }
}
