import 'package:bhagwat_geeta/pages/verse_view_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/scraper.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  static const routeName = "search_screen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Map searchResults = {};
  TextEditingController _searchController = TextEditingController();
  bool startedSearching = false;

  @override
  void initState() {
    super.initState();
  }

  getSearchResults(String query) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Searching...")
                ]))));
    final provider = Provider.of<Scraper>(context, listen: false);
    searchResults = await provider.getSearchResults(query);
    startedSearching = true;
    setState(() {});
    Navigator.pop(context);
    // loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
          CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 80),
              if (searchResults.length == 0)
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: startedSearching
                            ? Text("No Results Found!")
                            : Text("Start Searching..."))),
              if (searchResults.length != 0)
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('${searchResults.length} Results')),
              for (int i = 0; i < searchResults.length; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, VerseViewPage.routeName, arguments: {
                          "verseUrl":
                              searchResults.values.elementAt(i)["link"] + "/"
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 170,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(searchResults.keys.elementAt(i),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Samarkan',
                                          fontSize: 25)),
                                  SizedBox(height: 10),
                                  Text(
                                      searchResults.values
                                          .elementAt(i)["verse"]
                                          .toString()
                                          .trim(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      softWrap: true,
                                      style: TextStyle(color: Colors.white))
                                ],
                              )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.navigate_next,
                                color: Colors.white, size: 35),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
            ]))
          ]),
          buildSearchCard(),
        ]),
      ),
    );
  }

  Padding buildSearchCard() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            child: TextFormField(
                controller: _searchController,
                autofocus: true,
                onFieldSubmitted: (query) async {
                  getSearchResults(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      borderSide: BorderSide(color: Colors.white)),
                ))));
  }
}
