import 'dart:async';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yte;

import '../theme/theme.dart';

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
  String imgUrl;
  Uint8List imageDataBytes;
  AudioPlayer player;
  var x;
  Duration duration;
  Duration position;
  Duration buffPosition;
  PlayerState playerState;
  AudioProcessingState playerProcessingState;
  StreamSubscription<AudioProcessingState> _playerStateSubscription;

  @override
  void didChangeDependencies() async {
    if (!init) {
      var args = ModalRoute.of(context).settings.arguments as Map;
      lang = args["lang"];
      imageDataBytes = args["blurhash"];
      imgUrl = args["imgUrl"];

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

      setState(() {
        loading = false;
        init = true;
      });

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

      player.positionStream.listen((event) {
        position = event;
        if (position.inSeconds == duration.inSeconds) player.pause();
        setState(() {});
      });

      player.playerStateStream.listen((event) {
        playerState = event;
        print(event);
        setState(() {});
      });

      player.processingStateStream.listen((event) {
        // playerProcessingState = event;
        print(event);
        setState(() {});
      });

      // await AudioServiceBackground.setState(
      //   playing: true,
      //   controls: [],
      //   processingState: AudioProcessingState.completed,
      // );
      // await AudioServiceBackground.setMediaItem(MediaItem(
      //   title: "Hey Jude",
      //   album: "Bhagwat Geeta",
      //   id: "ABC",
      // ));
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
    // print(player.position.inSeconds.toString());
    // print(player.position.inMilliseconds);
    return WillPopScope(
      onWillPop: () async {
        player.dispose();
        print("disposed");
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: loading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 125.0, width: 125.0))
            : Stack(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(children: [
                            CachedNetworkImage(
                              imageUrl: imgUrl,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              placeholder: (BuildContext context, String url) =>
                                  Image.memory(imageDataBytes,
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.width,
                                      width: MediaQuery.of(context).size.width),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Bhagwat Geeta",
                                    style: TextStyle(
                                        fontFamily: "Samarkan",
                                        fontSize: 25,
                                        color: Colors.white)),
                              ),
                            )
                          ]),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Chapter $chapterNo",
                                style: TextStyle(
                                    color: Themes.primaryColor,
                                    fontSize: 35,
                                    fontFamily: "Samarkan")),
                            SizedBox(height: 5),
                            Text("$language",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 25,
                                    fontFamily: "Samarkan")),
                          ],
                        ),
                        InkWell(
                          onTap: playerState != null
                              ? playerState.playing
                                  ? () async {
                                      player.pause();
                                    }
                                  : () async {
                                      player.play();
                                    }
                              : null,
                          customBorder: CircleBorder(),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: playerState != null
                                    ? playerState.playing
                                        ? Themes.primaryColor
                                        : Colors.blueGrey
                                    : Colors.grey),
                            duration: Duration(milliseconds: 500),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 40,
                              child: playerState != null
                                  ? playerState.processingState ==
                                          ProcessingState.buffering
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white))
                                      : playerState.playing
                                          ? Icon(Icons.pause,
                                              size: 50, color: Colors.white)
                                          : Icon(Icons.play_arrow,
                                              size: 50, color: Colors.white)
                                  : CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FlutterSlider(
                                    disabled: playerState == null ||
                                            playerState.processingState ==
                                                ProcessingState.none ||
                                            playerState.processingState ==
                                                ProcessingState.loading
                                        ? true
                                        : false,
                                    values: [
                                      // _lowerValue
                                      playerState == null
                                          ? 0.0
                                          : position.inSeconds.roundToDouble()
                                    ],
                                    max: playerState == null
                                        ? 1.0
                                        : duration.inSeconds.toDouble(),
                                    min: 0,
                                    trackBar: FlutterSliderTrackBar(
                                        activeTrackBar: BoxDecoration(
                                            color: Themes.primaryColor)),
                                    tooltip: FlutterSliderTooltip(
                                        textStyle: TextStyle(
                                            fontSize: 0.01,
                                            color: Colors.white),
                                        boxStyle: FlutterSliderTooltipBox(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent))),
                                    handlerAnimation:
                                        FlutterSliderHandlerAnimation(
                                            curve: Curves.elasticOut,
                                            reverseCurve: Curves.bounceIn,
                                            duration:
                                                Duration(milliseconds: 500),
                                            scale: 1.5),
                                    handler: FlutterSliderHandler(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Material(
                                                type: MaterialType.canvas,
                                                elevation: 2,
                                                shape: CircleBorder(),
                                                child: Container()))),
                                    onDragCompleted: (handlerIndex, lowerValue,
                                        upperValue) async {
                                      _lowerValue = lowerValue;
                                      _upperValue = upperValue;
                                      print(lowerValue);
                                      print(x);
                                      await player.seek(Duration(
                                          seconds: lowerValue.round()));
                                      setState(() {});
                                    },
                                    onDragging: (handlerIndex, lowerValue,
                                        upperValue) async {
                                      _lowerValue = lowerValue;
                                      _upperValue = upperValue;
                                      print(lowerValue);
                                      print(x);
                                      await player.seek(Duration(
                                          seconds: lowerValue.round()));
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(position
                                          .toString()
                                          .split(".")[0]
                                          .replaceAll(":", " : ")),
                                      Text(duration
                                          .toString()
                                          .split(".")[0]
                                          .replaceAll(":", " : ")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () {
                            player.dispose();
                            print("disposed");
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 10),
                        Text("Chapter $chapterNo - $language",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ],
              ),
      )),
    );
  }
}

class MyBackgroundTask extends BackgroundAudioTask {
  // Initialise your audio task.
  onStart(Map<String, dynamic> params) {}
  // Handle a request to stop audio and finish the task.
  onStop() async {}
  // Handle a request to play audio.
  onPlay() {}
  // Handle a request to pause audio.
  onPause() {}
  // Handle a headset button click (play/pause, skip next/prev).
  onClick(MediaButton button) {}
  // Handle a request to seek to a position.
  onSeekTo(Duration position) {}
}
