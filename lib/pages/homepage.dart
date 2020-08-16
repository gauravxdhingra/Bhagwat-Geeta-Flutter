import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  bool init = false;

  dom.Document printdoc;

  @override
  void didChangeDependencies() async {
    if (!init) {
      String url = "https://bhagavadgita.io/";
      final response = await http.get(url);
      dom.Document document = parser.parse(response.body);
      printdoc = document;
      print(url);
      print(document);
    }
    setState(() {
      _isLoading = false;
      init = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(),
    );
  }
}
