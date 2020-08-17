import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/chapter_view_page.dart';
import 'pages/homepage.dart';
import 'pages/verse_view_Page.dart';
import 'provider/scraper.dart';

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
          primaryColor: Color(0xffff5521),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => HomePage(),
          ChapterViewPage.routeName: (context) => ChapterViewPage(),
          VerseViewPage.routeName: (context) => VerseViewPage(),
        },
      ),
    );
  }
}
