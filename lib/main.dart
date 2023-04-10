// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_design/account.dart';
import 'package:platform_design/bluetooth/bluetooth-fns.dart';

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
  final optionTabKey = GlobalKey();

  Widget _buildAndroidHomePage(BuildContext context) {
    return OptionTab(
      key: optionTabKey,
      androidDrawer: _AndroidDrawer(handleHudToggle: handleHudToggle),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return _buildAndroidHomePage(context);
  }

  void handleHudToggle(data) {
    print("Hud Change Data: $data");
    // bluetoothSend(connection, {txt})
  }
}

class _AndroidDrawer extends StatelessWidget {
  _AndroidDrawer({required this.handleHudToggle});
  final handleHudToggle;

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
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsTab(handleHudToggle: handleHudToggle)));
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
