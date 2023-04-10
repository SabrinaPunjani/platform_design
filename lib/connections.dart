// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// #enddocregion platform_imports
import 'settings_tab.dart';
import 'widgets.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

String clientId = '97255';
String clientSecret = '62c6935c0179e59a0d4556c84a8ce0302f3a2b1f';
String redirectUri = 'http://localhost:3000';

String stravaAuthUrl =
    'https://www.strava.com/oauth/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&approval_prompt=force&scope=read,activity:write';

final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(NavigationDelegate(
    onPageStarted: (String url) {
      print("HELLO PAGE STARTED");
      print(url);
    },
    onPageFinished: (String url) {
      print(url);
    },
    onNavigationRequest: (NavigationRequest request) {
      if (request.url.startsWith(redirectUri)) {
        if (request.url.contains('access_denied')) {
          // Navigator.of(context).pop();
        }

        String stravaTokenUrl = 'https://www.strava.com/api/v3/oauth/token';
        print("NAV REQUEST");
        print(request.url);
        // print(Uri.parse(request.url).queryParameters['code']);
        http
            .post(
              Uri.parse(stravaTokenUrl),
              body: jsonEncode(<String, String>{
                'client_id': clientId,
                'client_secret': clientSecret,
                'code': Uri.parse(request.url).queryParameters['code']!,
                'grant_type': 'authorization_code'
              }),
            )
            .then((res) => print(res.body.toString()));
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  ))
  ..loadRequest(Uri.parse(stravaAuthUrl));

class StravaWebView extends StatefulWidget {
  // final Function(String) onCodeReceived;

  // StravaWebView({required this.onCodeReceived});

  @override
  _StravaWebViewState createState() => _StravaWebViewState();
}

class _StravaWebViewState extends State<StravaWebView> {
  final String clientId = 'YOUR_CLIENT_ID';
  final String redirectUri = 'YOUR_REDIRECT_URI';

  @override
  Widget build(BuildContext context) {
    final url = Uri.https('www.strava.com', '/oauth/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'approval_prompt': 'force',
      'scope': 'read,activity:write',
    });

    return WebViewWidget(controller: controller);
  }
}

class ConnectionsTab extends StatelessWidget {
  static const title = 'Connect Accounts';
  static const androidIcon = Icon(Icons.account_tree_rounded);
  static const iosIcon = Icon(CupertinoIcons.link_circle_fill);

  const ConnectionsTab({super.key});

  Widget stravaConnectButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push<void>(
            context, MaterialPageRoute(builder: (context) => StravaWebView()))
      },
      child: Text('Connect with Strava'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(body: Center(child: stravaConnectButton(context))
        // appBar: AppBar(
        //   title: const Text('add strava login'), //being called below
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
    return _buildAndroid(context);
  }
}
