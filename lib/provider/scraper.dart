import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class Scraper with ChangeNotifier {
  Future<dom.Document> getWebpage(String url) async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    return document;
  }

  Future<Map<String, String>> getChapters(dom.Document document) async {
    List chapterNames = [];
    document
        .getElementsByClassName("card-header-title chapter-name")
        .forEach((element) {
      chapterNames.add(element.text);
    });
    print(chapterNames);

    List chapterMeaning = [];
    document.getElementsByClassName("chapter-meaning").forEach((element) {
      chapterMeaning.add(element.text);
    });
    print(chapterMeaning);

    Map<String, String> chapters = {};

    for (int i = 0; i < chapterNames.length; i++) {
      chapters[chapterNames[i]] = chapterMeaning[i];
    }
    return chapters;
  }

  int getTotalPagesChapter(dom.Document document) {
    List list = document
        .getElementsByClassName("pagination")[0]
        .getElementsByTagName("a");
    return int.parse(list[list.length - 1].text);
  }

  String getChapterDetails(dom.Document document) {
    return document.getElementsByTagName("p")[0].text;
  }

  Future<Map<String, String>> getVersesFromPage(dom.Document document) async {
    Map<String, String> verses = {};

    document.getElementsByClassName("card-body").forEach((element) {
      verses[element.getElementsByTagName("h4")[0].text] =
          element.getElementsByTagName("p")[0].text;
    });
    return verses;
  }

  
}
