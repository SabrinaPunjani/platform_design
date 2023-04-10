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
  final handleHudToggle;
  // final toggles;
  const SettingsTab({super.key, required this.handleHudToggle});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  var weather = false;
  var biometrics = false;
  var blindspot = false;
  var bike_stats = false;
  var timer = false;
  var altitude = false;

  void _onSwitchChanged(String id, bool value) {
    setState(() {
      switch (id) {
        case 'weather':
          weather = value;
          break;
        case 'biometrics':
          biometrics = value;
          break;
        case 'bike_stats':
          bike_stats = value;
          break;
        case 'blindspot':
          blindspot = value;
          break;
        case 'timer': 
          timer = value;
          break;
        case 'altitude':
          altitude = value;
          break;
      }
    });

    final hud_toggles = {
      "weather": weather,
      "biometrics": biometrics,
      "bike_stats": bike_stats,
      "blindspot": blindspot,
      "time": timer,
      "altitude": altitude,
    };
    widget.handleHudToggle(hud_toggles);
    // _stateChanged(id, value);
  }

  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
         ListTile(
          title: const Text('Timer'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: timer,
            onChanged: (value) => _onSwitchChanged('timer', value),
          ),
        ),
        ListTile(
          title: const Text('Weather'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: weather,
            onChanged: (value) => _onSwitchChanged('weather', value),
          ),
        ),
        ListTile(
          title: const Text('Biometrics'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: biometrics,
            onChanged: (value) => _onSwitchChanged('biometrics', value),
          ),
        ),
        ListTile(
          title: const Text('Bike Stats (Speed, Distance, Wattage, Cadence)'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: bike_stats,
            onChanged: (value) =>  _onSwitchChanged('bike_stats', value),
          ),
        ),
        ListTile(
          title: const Text('Blindspot Detection'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: blindspot,
            onChanged: (value) => _onSwitchChanged('blindspot', value),
          ),
        ),
         ListTile(
          title: const Text('Altitude'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: altitude,
            onChanged: (value) => _onSwitchChanged('altitude', value),
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
