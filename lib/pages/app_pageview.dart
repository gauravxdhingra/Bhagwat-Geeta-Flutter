import 'package:bhagwat_geeta/pages/favourites_page.dart';
import 'package:bhagwat_geeta/pages/homepage.dart';
import 'package:bhagwat_geeta/pages/settings_page.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:flutter/material.dart';

class AppPageview extends StatefulWidget {
  AppPageview({Key key}) : super(key: key);

  @override
  _AppPageviewState createState() => _AppPageviewState();
}

class _AppPageviewState extends State<AppPageview> {
  int index = 0;

  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              children: [
                HomePage(),
                FavouritesPage(),
                SettingsPage(),
              ],
            ),
            BlurBottomView(
              selectedItemColor: Themes.primaryColor,
              bottomNavigationBarItems: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text("Home")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), title: Text("Favourites")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), title: Text("Settings")),
              ],
              onIndexChange: (i) {
                setState(() {
                  index = i;
                });
                _controller.jumpToPage(i);
              },
              currentIndex: index,
            ),
          ],
        ),
      ),
    );
  }
}
