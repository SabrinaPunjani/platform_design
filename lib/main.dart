// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HUD.dart';
import 'connections.dart';
import 'settings_tab.dart';
import 'homepage.dart';
import 'widgets.dart';

void main() => runApp(const MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  const MyAdaptingApp({super.key});

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'IceHawkAR Companion Application',
      theme: ThemeData(
        // color theme for Material widgets.
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData.dark(),
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

// Shows a different type of scaffold depending on the platform.
//
// This file has the most amount of non-sharable code since it behaves the most
// differently between the platforms.
//
// These differences are also subjective and have more than one 'right' answer
// depending on the app and content.
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

  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: OptionTab.title,
            icon: OptionTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: NewsTab.title,
            icon: NewsTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: ProfileTab.title,
            icon: ProfileTab.iosIcon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: OptionTab.title,
              builder: (context) => OptionTab(key: optionTabKey),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: NewsTab.title,
              builder: (context) => const NewsTab(),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: ProfileTab.title,
              builder: (context) => const ProfileTab(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
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
            leading: NewsTab.androidIcon,
            title: const Text(NewsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const NewsTab()));
            },
          ),
          ListTile(
            leading: ProfileTab.androidIcon,
            title: const Text(ProfileTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const ProfileTab()));
            },
          ),
          // Long drawer contents are often segmented.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
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
        ],
      ),
    );
  }
}
// class BluetoothOffScreen extends StatelessWidget {
//   const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

//   final BluetoothState? state;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue,
//       body: Center(
//         child: Column(
//           // mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Icon(
//               Icons.bluetooth_disabled,
//               size: 200.0,
//               color: Colors.white54,
//             ),
//             Text(
//               'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
//               style: Theme.of(context)
//                   .primaryTextTheme
//                   .subtitle1
//                   ?.copyWith(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

