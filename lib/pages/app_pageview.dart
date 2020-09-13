import 'package:bhagwat_geeta/pages/favourites_page.dart';
import 'package:bhagwat_geeta/pages/homepage.dart';
import 'package:bhagwat_geeta/pages/search_screen.dart';
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
    return WillPopScope(
      onWillPop: () async {
        bool returnIf = false;
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Quit"),
                  content: Text("Are you sure?"),
                  actions: [
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                        returnIf = false;
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.pop(context);
                        returnIf = true;
                      },
                    ),
                  ],
                ));
        print(returnIf);
        return returnIf;
      },
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              WillPopScope(
                  onWillPop: () async {
                    setState(() {
                      _controller.jumpToPage(0);
                      index = 0;
                    });
                    return false;
                  },
                  child: FavouritesPage()),
              WillPopScope(
                  onWillPop: () async {
                    setState(() {
                      _controller.jumpToPage(0);
                      index = 0;
                    });
                    return false;
                  },
                  child: SettingsPage()),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
              BoxShadow(
                  blurRadius: 1.5, color: Colors.black12, spreadRadius: 1.5)
            ]),
            child: CustomNavigationBar(
              // borderRadius: Radius.circular(22),
              backgroundColor: Themes.primaryColor,
              onTap: (i) {
                if (i == 1) {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                  return;
                }
                setState(() {
                  i == 0
                      ? _controller.jumpToPage(i)
                      : _controller.jumpToPage(i - 1);
                  index = i;
                });
              },
              selectedColor: Colors.white,
              strokeColor: Colors.white,
              elevation: 1,
              scaleFactor: 0.3,
              unSelectedColor: Colors.white54,
              currentIndex: index,
              items: [
                CustomNavigationBarItem(icon: Icons.home),
                CustomNavigationBarItem(icon: Icons.search),
                CustomNavigationBarItem(icon: Icons.favorite),
                CustomNavigationBarItem(icon: Icons.settings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
