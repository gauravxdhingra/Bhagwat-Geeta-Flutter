import 'package:bhagwat_geeta/pages/about_page.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool init = false;
  bool loading = true;
  Box<Map> x;
  String lang = "eng";

  @override
  didChangeDependencies() async {
    if (!init) {
      x = await Hive.openBox<Map>("Geeta");
      var language = x.get("lang");
      if (language == null || language.toString() == "") {
        x.put("lang", {"lang": "eng"});
      }
      print(x.toMap()["lang"]["lang"]);
      lang = x.toMap()["lang"]["lang"];
      setState(() {
        init = true;
        loading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body:
            // Center(
            //   child: Image.asset(
            //     'assets/images/loading.gif',
            //     // height: 125.0,
            //     width: 125.0,
            //   ),
            // ),
            loading
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.translate),
                            onTap: () async {
                              x.toMap()["lang"]["lang"] == "eng"
                                  ? await x.put("lang", {"lang": "hi"})
                                  : await x.put("lang", {"lang": "eng"});
                              x.toMap()["lang"]["lang"] == "eng"
                                  ? lang = "eng"
                                  : lang = "hi";
                              print(x.toMap()["lang"]);
                              setState(() {});
                            },
                            title: Text("Switch Language"),
                            subtitle: x.toMap()["lang"]["lang"] == "eng"
                                ? Text("English")
                                : Text("Hindi"),
                          ),
                          ListTile(
                            // leading: Icon(FlutterIcons.hinduism_mco),
                            onTap: () {
                              Navigator.pushNamed(context, AboutPage.routeName);
                            },
                            title: Text("About Bhagwat Geeta"),
                          ),
                          ListTile(
                            // leading: Icon(Icons.share),
                            onTap: () async {
                              await Share.share(
                                  "Check out this amazing app - Shrimad Bhagwat Geeta\n${Themes.appUrl}\n\nJai Shree Krishna🙏🏻");
                            },
                            title: Text("Share This App"),
                          ),
                          ListTile(
                            // leading: Icon(Icons.star),
                            onTap: () async {
                              _launchURL() async {
                                const url = Themes.appUrl;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }

                              await _launchURL();
                            },
                            title: Text("Rate Us!"),
                          ),
                        ],
                      ),
                      if (lang == "eng")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text("।। Jai Shree Krishna ।।",
                              style: TextStyle(
                                  fontFamily: "Samarkan",
                                  fontSize: 22,
                                  color: Colors.grey.withOpacity(0.5),
                                  letterSpacing: 1.1)),
                        ),
                      if (lang == "hi")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text("।। जय श्री कृष्णा ।।",
                              style: TextStyle(
                                  fontFamily: "Samarkan",
                                  fontSize: 22,
                                  color: Colors.grey.withOpacity(0.5),
                                  letterSpacing: 1.1)),
                        ),
                    ],
                  ),
      ),
    );
  }
}
