import 'package:bhagwat_geeta/pages/verse_view_Page.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavouritesPage extends StatefulWidget {
  FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  bool init = false;
  bool loading = true;
  Box<Map> hive;
  String lang = "";
  var update;

  @override
  void didChangeDependencies() async {
    final args = ModalRoute.of(context).settings.arguments;
    print(args);
    hive = await Hive.openBox<Map>("Geeta");
    if (!init) {
      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  changeLanguage() async {
    setState(() {
      loading = true;
    });
    if (hive.toMap()["lang"]["lang"] == "hi") {
      hive.put("lang", {"lang": "eng"});
      lang = "eng";
    } else {
      hive.put("lang", {"lang": "hi"});
      lang = "hi";
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.favorite),
        title: Text("Favourites"),
        actions: [
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () async {
              // Navigator.pushNamed(context, SearchScreen.routeName);
              await changeLanguage();
            },
          ),
        ],
      ),
      body: loading
          ? Container()
          : hive.get("fav") != null && hive.get("fav") != {}
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, i) => Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () async {
                            update = await Navigator.pushNamed(
                                context, VerseViewPage.routeName,
                                arguments: {
                                  "verseUrl":
                                      hive.get("fav").keys.elementAt(i)
                                });
                            if (update == true) setState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: -5,
                                    right: -10,
                                    child: Icon(Icons.navigate_next,
                                        color: Colors.white, size: 35)),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        lang == "hi"
                                            ? "अध्याय " +
                                                hive
                                                    .get("fav")
                                                    .keys
                                                    .elementAt(i)
                                                    .toString()
                                                    .split("/")[2] +
                                                ", श्लोक " +
                                                hive
                                                    .get("fav")
                                                    .keys
                                                    .elementAt(i)
                                                    .toString()
                                                    .split("/")[4]
                                            : "Chapter " +
                                                hive
                                                    .get("fav")
                                                    .keys
                                                    .elementAt(i)
                                                    .toString()
                                                    .split("/")[2] +
                                                ", Verse " +
                                                hive
                                                    .get("fav")
                                                    .keys
                                                    .elementAt(i)
                                                    .toString()
                                                    .split("/")[4],
                                        style: Themes.homeChapterHead),
                                    SizedBox(height: 10),
                                    Text(
                                        lang == "hi"
                                            ? hive
                                                .get("fav")
                                                .values
                                                .elementAt(
                                                    i)["verseSanskrit"]
                                            : hive
                                                .get("fav")
                                                .values
                                                .elementAt(
                                                    i)["translation"],
                                        maxLines: 4,
                                        style: Themes.homeChapterMeaning
                                            .copyWith(
                                                fontSize:
                                                    lang == "hi" ? 17 : 17,
                                                fontFamily: lang == "hi"
                                                    ? 'KrutiDev'
                                                    : "Samarkan",
                                                color: Colors.white
                                                    .withOpacity(0.75))),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemCount:
                      hive.get("fav") != null ? hive.get("fav").length : 0,
                )
              : Center(
                  child: Text("No Favourites Added Yet!"),
                ),
    );
  }
}
