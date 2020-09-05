import 'package:bhagwat_geeta/pages/favourites_page.dart';
import 'package:bhagwat_geeta/pages/homepage.dart';
import 'package:bhagwat_geeta/pages/settings_page.dart';
import 'package:bhagwat_geeta/theme/theme.dart';
import 'package:blur_bottom_bar/blur_bottom_bar.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
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
        body: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            FavouritesPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
          backgroundColor: Themes.primaryColor,
          onTap: (i) {
            setState(() {
              index = i;
            });
            _controller.jumpToPage(i);
          },
          selectedColor: Colors.white,
          strokeColor: Colors.white,
          elevation: 30,
          scaleFactor: 0.3,
          unSelectedColor: Colors.white54,
          currentIndex: index,
          items: [
            CustomNavigationBarItem(
              icon: Icons.home,
            ),
            CustomNavigationBarItem(
              icon: Icons.favorite,
            ),
            CustomNavigationBarItem(
              icon: Icons.settings,
            ),
          ],
        ),
      ),
    );
  }
}
