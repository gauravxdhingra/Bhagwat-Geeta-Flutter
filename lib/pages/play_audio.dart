import 'package:flutter/material.dart';

class PlayAudio extends StatefulWidget {
  PlayAudio({Key key}) : super(key: key);
  static const routeName = "play_audio";
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  bool init = false;
  bool loading = true;

  String lang;

  @override
  void didChangeDependencies() {
    if (!init) {
      var args = ModalRoute.of(context).settings.arguments as Map;
      lang = args["lang"];

      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  List hiList = [
    "https://www.youtube.com/watch?v=B6uV7enE8Ek",
    "https://www.youtube.com/watch?v=3Dygl8-1Mm0",
    "https://www.youtube.com/watch?v=ZWqUYD3NXTM",
    "https://www.youtube.com/watch?v=5yWJTNicjfk",
    "https://www.youtube.com/watch?v=CvhxVDiOBEA",
    "https://www.youtube.com/watch?v=jMquMUqE80c",
    "https://www.youtube.com/watch?v=1twYXeS1pvo",
    "https://www.youtube.com/watch?v=q-1SwulnKY8",
    "https://www.youtube.com/watch?v=2TEOA3uX5MA",
    "https://www.youtube.com/watch?v=bkDFat8cxg8",
    "https://www.youtube.com/watch?v=saIOU90rG9E",
    "https://www.youtube.com/watch?v=ng9igotmFvs",
    "https://www.youtube.com/watch?v=JsQP2WJwOKE",
    "https://www.youtube.com/watch?v=mVVQkb8t8zo",
    "https://www.youtube.com/watch?v=_TjdOXgDp-4",
    "https://www.youtube.com/watch?v=Cgvx--lhKxA",
    "https://www.youtube.com/watch?v=W20fcNzYOu0",
    "https://www.youtube.com/watch?v=i3i5vbiPc2I"
  ];

  List engList = [
    "https://www.youtube.com/watch?v=t73uLIgRvjk",
    "https://www.youtube.com/watch?v=IjTXzH0Otgw",
    "https://www.youtube.com/watch?v=uF2u6ceEzlE",
    "https://www.youtube.com/watch?v=IXyD440L5H8",
    "https://www.youtube.com/watch?v=s0wrprqFtdE",
    "https://www.youtube.com/watch?v=XUq3Y6KWO7w",
    "https://www.youtube.com/watch?v=nbQv7aEFAYo",
    "https://www.youtube.com/watch?v=caiiELOaRRw",
    "https://www.youtube.com/watch?v=bzrX_-NhmYI",
    "https://www.youtube.com/watch?v=0odzBKQac3w",
    "https://www.youtube.com/watch?v=hxGm592vse0",
    "https://www.youtube.com/watch?v=YDqgrJfgMuM",
    "https://www.youtube.com/watch?v=uR-olEdoBqg",
    "https://www.youtube.com/watch?v=466GiSlGqKo",
    "https://www.youtube.com/watch?v=YdOyrfPzmFY",
    "https://www.youtube.com/watch?v=8LHbWG9xkco",
    "https://www.youtube.com/watch?v=TChDXoRE2OM",
    "https://www.youtube.com/watch?v=bj8h4qxB7Qg",
    "https://www.youtube.com/watch?v=JXCBzQlNTVw"
  ];

  List sansList = [
    "https://www.youtube.com/watch?v=16yApGx6NEs",
    "https://www.youtube.com/watch?v=WuZqx82rsos",
    "https://www.youtube.com/watch?v=e3-oIBpyVu0",
    "https://www.youtube.com/watch?v=0VKXmlBft-E",
    "https://www.youtube.com/watch?v=6btGhE7_7-E",
    "https://www.youtube.com/watch?v=zc_4CcKipFs",
    "https://www.youtube.com/watch?v=abYKS195DME",
    "https://www.youtube.com/watch?v=mMBdptd-p4w",
    "https://www.youtube.com/watch?v=HY2N3rr9mB0",
    "https://www.youtube.com/watch?v=764uwNhcVmA",
    "https://www.youtube.com/watch?v=B1ChG0dmUrc",
    "https://www.youtube.com/watch?v=R4xZXNZbD10",
    "https://www.youtube.com/watch?v=dlsx_6q4kSQ",
    "https://www.youtube.com/watch?v=JAvU5rElSK0",
    "https://www.youtube.com/watch?v=CUu_iNRhxGM",
    "https://www.youtube.com/watch?v=rSs9oUPJSJQ",
    "https://www.youtube.com/watch?v=zqjEQUg04Xg",
    "https://www.youtube.com/watch?v=YyRX0veGjnc",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(),
    ));
  }
}
