// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class SettingsTab extends StatefulWidget {
  static const title = 'HUD Layout';
  static const androidIcon = Icon(Icons.bolt);
  static const iosIcon = Icon(CupertinoIcons.bolt);

  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  var weather = false;
  var biometrics = false;
  var blindspot = false;
  var bikestats = false;

  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
          title: const Text('Weather'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: weather,
            onChanged: (value) => setState(() => weather = value),
          ),
        ),
        ListTile(
          title: const Text('Biometrics'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: biometrics,
            onChanged: (value) => setState(() => biometrics = value),
          ),
        ),
        ListTile(
          title: const Text('Bike Stats (Speed, Distance, Wattage, Cadence)'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: bikestats,
            onChanged: (value) => setState(() => bikestats = value),
          ),
        ),
        ListTile(
          title: const Text('Blindspot Detection'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: blindspot,
            onChanged: (value) => setState(() => blindspot = value),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsTab.title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildList(),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
