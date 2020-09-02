import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/loading.gif',
          // height: 125.0,
          width: 125.0,
        ),
      ),
    );
  }
}
