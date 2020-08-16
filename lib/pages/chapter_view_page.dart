import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChapterViewWidget extends StatefulWidget {
  ChapterViewWidget({Key key}) : super(key: key);

  @override
  _ChapterViewWidgetState createState() => _ChapterViewWidgetState();
}

class _ChapterViewWidgetState extends State<ChapterViewWidget> {
  bool _isLoading = true;
  bool init = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
