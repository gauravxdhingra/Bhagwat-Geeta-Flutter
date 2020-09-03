import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    return Scaffold(
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
                  ],
                ),
    );
  }
}
