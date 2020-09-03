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
      chapterNames.add(element.text.split(".")[1].trim());
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

  List<Map<String, String>> getVersesFromPage(dom.Document document) {
    List<Map<String, String>> verses = [];

    document.getElementsByClassName("card-body").forEach((element) {
      verses.add({
        'verseNo': element.getElementsByTagName("h4")[0].text,
        'verse': element.getElementsByTagName("p")[0].text,
        'url': element.getElementsByTagName("a")[2].attributes["href"],
      });
    });
    return verses;
  }

  Map<String, String> getFullVerse(dom.Document document, {bool eng = false}) {
    Map<String, String> verse = {};
    String title = "";
    String verseSanskrit = "";
    String transliteration = "";
    String wordMeanings = "";
    String translation = "";

    title = document.getElementsByClassName("font-up font-bold mt-2")[0].text;
    if (!eng) {
      title = "अध्याय" +
          title.split("Chapter")[1].split(",")[0] +
          ", " +
          "श्लोक" +
          title.split("Verse")[1];
      // title.replaceAll("Chapter", "अध्याय");
      // title.replaceAll("Verse", "श्लोक");
      print(title);
    }

    verseSanskrit = document.getElementsByClassName("verse-sanskrit")[0].text;
    if (eng)
      transliteration =
          document.getElementsByClassName("verse-transliteration")[0].text;
    wordMeanings = document.getElementsByClassName("verse-word")[0].text;
    translation = document.getElementsByClassName("verse-meaning")[0].text;

    // No Transliteration for Hindi
    // शब्दार्थ   word meanings
    // अनुवाद   translation

    verse = {
      "title": title,
      "verseSanskrit": verseSanskrit,
      "transliteration": transliteration,
      "wordMeanings": wordMeanings,
      "translation": translation,
    };
    return verse;
  }

  Map searchResults = {};

  Future<Map> getSearchResults(String query) async {
    dom.Document searchPage =
        await getWebpage("https://bhagavadgita.io/search?query=$query");
    var cards = searchPage.getElementsByClassName("card-body");
    searchResults = {};
    cards.forEach((element) {
      searchResults[element.getElementsByTagName("h4")[0].text] = {
        "verse": element.getElementsByTagName("p")[0].text,
        "link": element.getElementsByTagName("a")[0].attributes["href"],
      };
    });
    print(searchResults);
    return searchResults;
  }
}
