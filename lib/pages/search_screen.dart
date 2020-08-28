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
  bool init = false;
  bool loading = false;
  Map searchResults = {};

  @override
  void didChangeDependencies() async {
    if (!init) {
      setState(() {
        init = true;
        loading = false;
      });
    }
    super.didChangeDependencies();
  }

  getSearchResults(String query) async {
    // loading = true;
    // setState(() {});
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Searching..."),
            ],
          ),
        ),
      ),
    );
    final provider = Provider.of<Scraper>(context, listen: false);
    searchResults = await provider.getSearchResults(query);
    // setState(() {});
    Navigator.pop(context);
    // loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 100),
              if (searchResults.length == 0) Container(),
              for (int i = 0; i < searchResults.length; i++)
                InkWell(
                    onTap: () {
                      // Text(searchResults.values.elementAt(i)["link"]),
                    },
                    child: Container(
                        child: Column(
                      children: [
                        Text(searchResults.keys.elementAt(i)),
                        Text(searchResults.values
                            .elementAt(i)["verse"]
                            .toString()
                            .trim())
                      ],
                    )))
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
