import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/desktop/pages/archive_page.dart';
import 'package:bnotes/desktop/pages/home_page.dart';
import 'package:bnotes/desktop/pages/search_page.dart';
import 'package:bnotes/desktop/pages/settings_page.dart';
import 'package:bnotes/pages/archive_page.dart';
import 'package:bnotes/pages/home_page.dart';
import 'package:bnotes/pages/search_page.dart';
import 'package:bnotes/pages/settings_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ScrawlDesktop extends StatefulWidget {
  const ScrawlDesktop({Key? key}) : super(key: key);

  @override
  _ScrawlDesktopState createState() => _ScrawlDesktopState();
}

class _ScrawlDesktopState extends State<ScrawlDesktop> {
  final _pageList = <Widget>[
    new HomePage(
      title: '',
    ),
    new ArchivePage(),
    new SearchPage(),
    new SettingsPage(),
  ];
  int _page = 0;
  bool isExtended = false;

  Widget menuItem(String title, int index, IconData? icon) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    // return Text(
    //   title,
    //   style: TextStyle(
    //     fontWeight: _page == index ? FontWeight.bold : FontWeight.normal,
    //     color: _page == index
    //         ? FlexColor.jungleDarkPrimary
    //         : (darkModeOn ? Colors.white : Colors.black),
    //   ),
    // );
    return Tooltip(
      message: title,
      child: Icon(
        icon,
        color: _page == index
            ? FlexColor.jungleDarkPrimary
            : (darkModeOn ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: WindowTopBar(naviChildren: [
          TextButton(
            child: menuItem('Notes', 0, Iconsax.note),
            onPressed: () {
              setState(() {
                _page = 0;
              });
            },
          ),
          TextButton(
            child: menuItem('Archive', 1, Iconsax.archive),
            onPressed: () {
              setState(() {
                _page = 1;
              });
            },
          ),
          TextButton(
            child: menuItem('Search', 2, Iconsax.search_normal),
            onPressed: () {
              setState(() {
                _page = 2;
              });
            },
          ),
          TextButton(
            child: menuItem('Settings', 3, Iconsax.menu),
            onPressed: () {
              setState(() {
                _page = 3;
              });
            },
          ),
        ]),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _pageList[_page],
        ),
      ),
    );
  }
}

class WindowTopBar extends StatefulWidget {
  final List<Widget> naviChildren;
  const WindowTopBar({Key? key, required this.naviChildren}) : super(key: key);

  @override
  State<WindowTopBar> createState() => _WindowTopBarState();
}

class _WindowTopBarState extends State<WindowTopBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WindowTitleBarBox(
          child: Row(
            children: [
              WindowButtons(),
              Expanded(child: MoveWindow()),
              Row(
                children: widget.naviChildren,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_close,
            size: 16,
          ),
          ontap: () {
            appWindow.close();
          },
        ),
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_minimize,
            size: 16,
          ),
          ontap: () {
            appWindow.minimize();
          },
        ),
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_maximize,
            size: 16,
          ),
          ontap: () {
            appWindow.maximizeOrRestore();
          },
        ),
      ],
    );
  }
}

class WindowIconButtons extends StatefulWidget {
  final Icon icon;
  final Function ontap;
  const WindowIconButtons({Key? key, required this.icon, required this.ontap})
      : super(key: key);

  @override
  State<WindowIconButtons> createState() => _WindowIconButtonsState();
}

class _WindowIconButtonsState extends State<WindowIconButtons> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => widget.ontap(),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: darkModeOn
                ? Colors.grey.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
