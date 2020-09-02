import 'dart:io';

import 'package:animations/animations.dart';
import 'package:bhagwat_geeta/pages/app_pageview.dart';
import 'package:bhagwat_geeta/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/chapter_view_page.dart';
import 'pages/homepage.dart';
import 'pages/verse_view_Page.dart';
import 'provider/scraper.dart';

const primaryColor = Color(0xffff5521);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);

  var prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  bool init = prefs.getBool("init") ?? false;

  if (!init)
    SharedPreferences.getInstance()
        .then((value) => value.setBool("init", true))
        .then((value) async {
      var x = await Hive.openBox<Map>("Geeta");

      Map blurhash = {
        "100": "LeI}LV~nE3IB?a%MRkoHNaafRkkC",
        "101": "LUK1Q^01WCWF_MD%t3WE4;%KV[of",
        "102": "LaFiPiR%4ot8~pfkIAs:t8ofj?ae",
        "103": "LUKwag-n0Mf,b{t6xUs.9HbcxtoJ",
        "104": "LKLp?3ITMyxG_NNMM{NH4px]M|WA",
        "105": "LWPFMwEzL#WXyXWCMxR*VYWqEMs+",
        "106": "LND+h*WF0MIpS4s.M{oM0MxX%LbH",
        "107": "LDJtq.uP^bD+_4%KIooID\$I9NGRi",
        "108": "L;K^mKM~M{bb_NWEe-aztmt6ofae",
        "109": "LOGut85vMe%K_LH@VEs+B?o}ogM|",
        "110": "LSKJ-vbE02jvt8jsfRe:IWa#bbjY",
        "111": "LRH_G8_20M9G~q?bIUROtTo}M{nh",
        "112": "LDGR6TDkDj?G0g9c%ftP9]xsR+9I",
        "113": "LYJQ_oV?8|oI_4RPjDa\$T1ocobjZ",
        "114": "LKGkzL0L02?a*0ROIUxv4;t7xtRj",
        "116": "LDKA+v?cRoxw=dj]s+Rk03RiR%Rj",
        "117": "LQIh53s70MtT%js+NGo#D*W?NGoI",
        "118": "LTIqx~RONHIpyGWraJoI0MWXV?t6",
        "119": "LCFYJJ0g0QV{%}H[%gS}75Dj^%x[",
        "120": "LDAwPPZit,In%O%hROaK0KtlQ,s:",
        "121": "LxJa=*%MR%Ny%jxun~kDE1Rjs:WX",
        "122": "LZLMt:.8IBRQ~XtSM{ozBDX9nNIq",
        "123": "LED9%]EMEL.70h%fwhRj9urZSLRk",
        "124": "LgHLedS~\$QJ60gr?NZjYJ6WURks:",
        "125": "LMDJ,wxa0hM|70kC\$hk95oRk+_t7",
        "126": "LoHndGI.Isf,.TsSRnNyTesQWCkD",
        "127": "LEH,-equ57ERE.xoKiFf16+[bvcE",
        "128": "LKGRO@\${0NE39_t7f5V=Rj9wNK-P",
        "129": "LCHw_RQT9HE2t,~AICM{0#xur@x[",
        "130": "LJL4H6-919Nv?ax_-nM~0OaJMyt3",
        "131": "LGL{;J0L59=^ctIUNeozypIqWrRj",
        "132": "LHKdeJ-90i\$%BaN1IYW=75N#N0xU",
        "134": "LIK0+omm01%3t-XUE3adR.V_\${tQ",
        "135": "LXMr;vOrh}ov};W=#mWU9aaftQjZ",
        "136": "LBL4A-%P7Op05_kD%4jK5SRiM|s:",
        "137": "LFL{qv},M%IX5PjDX3x]9IskaKNa",
        "138": "LEK-8MNO0OR#jZe=M}b0Dl%fIVs8",
        "139": "LLKKQM?caJI9%%o#V?aeJ=IUNIt7",
        "140": "LQL377kV0%soNgnixaWV9[flw]js"
      };
      x.put("blurhash", blurhash);
      // print(x.toMap());
    });
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: primaryColor,
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Scraper(),
      child: MaterialApp(
        title: 'Bhagwat Geeta',
        theme: ThemeData(
          primaryColor: Color(0xffff5521),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal),
            },
          ),
        ),
        routes: {
          '/': (context) => AppPageview(),
          // HomePage(),
          ChapterViewPage.routeName: (context) => ChapterViewPage(),
          VerseViewPage.routeName: (context) => VerseViewPage(),
          SearchScreen.routeName: (context) => SearchScreen(),
        },
      ),
    );
  }
}
// [47, 72, 43, 42, 29, 47, 30, 28, 34, 42, 55, 20, 35, 27, 20, 24, 28, 78]
// https://bhagavadgita.io/chapter/18/verse/1/
