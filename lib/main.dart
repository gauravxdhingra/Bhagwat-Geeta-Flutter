import 'package:bhagwat_geeta/pages/chapter_view_page.dart';
import 'package:bhagwat_geeta/pages/homepage.dart';
import 'package:bhagwat_geeta/pages/verse_view_Page.dart';
import 'package:bhagwat_geeta/provider/scraper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => HomePage(),
          ChapterViewPage.routeName: (context) => ChapterViewPage(),
          VerseViewPage.routeName:(context)=> VerseViewPage(),
        },
      ),
    );
  }
}
