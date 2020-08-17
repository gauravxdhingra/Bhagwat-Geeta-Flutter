import 'package:flutter/material.dart';

class VerseViewPage extends StatefulWidget {
  VerseViewPage({Key key}) : super(key: key);

  @override
  _VerseViewPageState createState() => _VerseViewPageState();
}

class _VerseViewPageState extends State<VerseViewPage> {

  bool _isLoading = true;
  bool init = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
