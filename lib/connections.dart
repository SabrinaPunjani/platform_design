// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'; // show SignInOption;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// #enddocregion platform_imports
import 'settings_tab.dart';
import 'widgets.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class ConnectionsTab extends StatelessWidget {
  const ConnectionsTab({Key? key}) : super(key: key);
  static const title = 'Social/Account Connections';
  static const androidIcon = Icon(Icons.link);
  static const iosIcon = Icon(CupertinoIcons.link);

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add strava login'), //being called below
      ),
    );
  }
  // ===========================================================================
  // Non-shared code below because on iOS, the settings tab is nested inside of
  // the profile tab as a button in the nav bar.
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text('Login with Google'))));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: build(context), //calling buildbody
    );
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
  }
}
