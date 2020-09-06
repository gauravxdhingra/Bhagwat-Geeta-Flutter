import 'package:bhagwat_geeta/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
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
  @override
  didChangeDependencies() async {
    if (!init) {
      x = await Hive.openBox<Map>("Geeta");
      var lang = x.get("lang");
      if (lang == null || lang.toString() == "") {
        x.put("lang", {"lang": "eng"});
      }
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
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.translate),
                        onTap: () async {
                          x.toMap()["lang"]["lang"] == "eng"
                              ? await x.put("lang", {"lang": "hi"})
                              : await x.put("lang", {"lang": "eng"});
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
                        onTap: () async {},
                        title: Text("Share This App"),
                      ),
                      ListTile(
                        // leading: Icon(Icons.star),
                        onTap: () async {
                          _launchURL() async {
                            const url = 'https://flutter.dev';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          await _launchURL();
                        },
                        title: Text("Rate Us !"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
