// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatelessWidget {
  static const title = 'Signup/Login';
  static const androidIcon = Icon(Icons.account_circle_rounded);
  static const iosIcon = Icon(CupertinoIcons.person);

  const AccountTab({super.key});

  Widget _buildBody(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // title: const Text('add strava login'), //being called below
        // ),
        );
  }
  // ===========================================================================
  // Non-shared code below because on iOS, the settings tab is nested inside of
  // the profile tab as a button in the nav bar.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: _buildBody(context), //calling buildbody
    );
  }

  @override
  Widget build(context) {
    // return PlatformWidget(
    //   androidBuilder: _buildAndroid,
    // );
    return _buildAndroid(context);
  }
}
