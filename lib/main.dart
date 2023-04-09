// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_design/account.dart';

import 'HUD.dart';
import 'connections.dart';
import 'settings_tab.dart';
import 'homepage.dart';
import 'widgets.dart';

void main() => runApp(const MyApp());

// STYLE DEFINITIONS
MaterialColor primarySwatch = Colors.blue;

//! TODO - Fix this theme
// TextTheme textTheme = GoogleFonts.interTextTheme(
//     // Theme.of(context).textTheme.apply(fontSizeFactor: 0.9)),

//TextTheme(
//   bodyText1: TextStyle(fontSize: 12.0),
//   bodyText2: TextStyle(fontSize: 12.0),
//   button: TextStyle(fontSize: 14.0),
// ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'IceHawkAR Companion Application',
      themeMode: ThemeMode.light, // Force light mode for now
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context)
              .textTheme
              .apply(fontSizeFactor: 0.95)), // Make fonts a slight bit smaller
          fontFamily: 'Inter',
          primarySwatch: primarySwatch),
      darkTheme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: primarySwatch),
      builder: (context, child) {
        return CupertinoTheme(
          // Instead of letting Cupertino widgets auto-adapt to the Material
          // theme (which is green), this app will use a different theme
          // for Cupertino (which is blue by default).
          data: const CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      home: const PlatformAdaptingHomePage(),
    );
  }
}

class PlatformAdaptingHomePage extends StatefulWidget {
  const PlatformAdaptingHomePage({super.key});

  @override
  State<PlatformAdaptingHomePage> createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  // This app keeps a global key for the songs tab because it owns a bunch of
  // data. Since changing platform re-parents those tabs into different
  // scaffolds, keeping a global key to it lets this app keep that tab's data as
  // the platform toggles.
  //
  // This isn't needed for apps that doesn't toggle platforms while running.
  final optionTabKey = GlobalKey();

  // In Material, this app uses the hamburger menu paradigm and flatly lists
  // all 4 possible tabs. This drawer is injected into the songs tab which is
  // actually building the scaffold around the drawer.
  Widget _buildAndroidHomePage(BuildContext context) {
    return OptionTab(
      key: optionTabKey,
      androidDrawer: _AndroidDrawer(),
    );
  }

  // On iOS, the app uses a bottom tab paradigm. Here, each tab view sits inside
  // a tab in the tab scaffold. The tab scaffold also positions the tab bar
  // in a row at the bottom.
  //
  // An important thing to note is that while a Material Drawer can display a
  // large number of items, a tab bar cannot. To illustrate one way of adjusting
  // for this, the app folds its fourth tab (the settings page) into the
  // third tab. This is a common pattern on iOS.

  // Widget _buildIosHomePage(BuildContext context) {
  //   return CupertinoTabScaffold(
  //     tabBar: CupertinoTabBar(
  //       items: const [
  //         BottomNavigationBarItem(
  //           label: OptionTab.title,
  //           icon: OptionTab.iosIcon,
  //         ),
  //         BottomNavigationBarItem(
  //           label: SettingsTab.title,
  //           icon: SettingsTab.iosIcon,
  //         ),
  //         BottomNavigationBarItem(
  //           label: ConnectionsTab.title,
  //           icon: ConnectionsTab.iosIcon,
  //         ),
  //       ],
  //     ),
  //     tabBuilder: (context, index) {
  //       switch (index) {
  //         case 0:
  //           return CupertinoTabView(
  //             defaultTitle: OptionTab.title,
  //             builder: (context) => OptionTab(key: optionTabKey),
  //           );
  //         case 1:
  //           return CupertinoTabView(
  //             defaultTitle: SettingsTab.title,
  //             builder: (context) => const SettingsTab(),
  //           );
  //         case 2:
  //           return CupertinoTabView(
  //             defaultTitle: ConnectionsTab.title,
  //             builder: (context) => const ConnectionsTab(),
  //           );
  //         default:
  //           assert(false, 'Unexpected tab');
  //           return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    // return PlatformWidget(
    //   androidBuilder: _buildAndroidHomePage,
    //   // iosBuilder: _buildIosHomePage,
    // );
    return _buildAndroidHomePage(context);
  }
}

class _AndroidDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 6, 9, 77)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Icon(
                Icons.account_circle,
                color: Color.fromARGB(255, 23, 8, 88),
                size: 96,
              ),
            ),
          ),
          ListTile(
            leading: OptionTab.androidIcon,
            title: const Text(OptionTab.title),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SettingsTab.androidIcon,
            title: const Text(SettingsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const SettingsTab()));
            },
          ),
          ListTile(
            leading: ConnectionsTab.androidIcon,
            title: const Text(ConnectionsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConnectionsTab()));
            },
          ),
          // Long drawer contents are often segmented.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ListTile(
            leading: AccountTab.androidIcon,
            title: const Text(AccountTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const AccountTab()));
            },
          ),
          ListTile(
            leading: NewsTab.androidIcon,
            title: const Text(NewsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const NewsTab()));
            },
          ),
        ],
      ),
    );
  }
}
