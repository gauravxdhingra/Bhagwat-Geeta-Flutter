import 'dart:io';

import 'package:flutter/material.dart';

class ScreenshotScreen extends StatefulWidget {
  ScreenshotScreen({Key key}) : super(key: key);
  static const routeName = "screnshot_screen";
  @override
  _ScreenshotScreenState createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen> {
  bool init = false;
  bool loading = true;
  File image;

  @override
  void didChangeDependencies() async {
    if (!init) {
      image = ModalRoute.of(context).settings.arguments;
      setState(() {
        loading = false;
        init = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: loading
            ? CircularProgressIndicator()
            : Container(
                child: Column(
                  children: [
                    Image.file(image),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
