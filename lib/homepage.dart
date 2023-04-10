// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// import 'package:flutter_blue/flutter_blue.dart';
import 'package:platform_design/bluetooth/bluetooth-connect-serial.dart';
import 'package:platform_design/bluetooth/bluetooth-fns.dart';
import 'package:platform_design/components/altitude-widget.dart';
import 'package:platform_design/components/display-weather.dart';
import 'package:platform_design/components/weather-fetcher.dart';
import 'package:platform_design/control-panel.dart';
import 'package:platform_design/utils/api.dart';
import 'package:platform_design/utils/definitions.dart';

import 'components/timer-button.dart';
import 'dart:async';

var template = {
  "timer": false,
  "weather": null,
  "hud_toggles": null,
};

class OptionTab extends StatefulWidget {
  static const title = 'Home';
  static const androidIcon = Icon(Icons.home);
  static const iosIcon = Icon(CupertinoIcons.home);

  const OptionTab({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<OptionTab> createState() => _OptionTabState();
}

class _OptionTabState extends State<OptionTab> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String bluetoothAddress = "...";
  String bluetoothName = "...";

  BluetoothDevice? connectedDevice = null;
  BluetoothConnection? conn = null;

  SystemStatus status = SystemStatus.off;

  Map<String, dynamic> weather = {};
  double altitude = 0;
  bool timer = false;

  static const _itemsLength = 1;

  bool isScanning = false;
  late List<MaterialColor> colors;
  late List<String> songNames;

  @override
  void initState() {
    super.initState();

    getConnectedDevice().then((device) {
      setState(() {
        connectedDevice = device;
        status = SystemStatus.connected;
      });

      // set connection
      BluetoothConnection.toAddress(connectedDevice?.address).then((_connection) {
        setState(() {
          conn = _connection;
        });
      });


    }).catchError((e) {
      connectedDevice = null;
      status = SystemStatus.off;
    });

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // print(FlutterBluetoothSerial.instance.getBondedDevices());
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          bluetoothAddress = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((devices) => {devices.map((device) => print(device.address))});

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        bluetoothName = name!;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // // Discoverable mode is disabled when Bluetooth gets disabled
        // _discoverableTimeoutTimer = null;
        // _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  void _refreshData() {
    getConnectedDevice().then((device) {
      setState(() {
        connectedDevice = device;
      });
    });
    return;
    // return Future.delayed(
    //   // This is just an arbitrary delay that simulates some network activity.
    //   const Duration(seconds: 2),
    //   () => setState(() => _setData()),
    // );
  }

  void handleWeatherUpdate(weatherData) {
    // print("yo\n");
    // print({: weatherData});
    bluetoothSend(conn, jsonEncode({"weather": weatherData}));
    setState(() {
      weather = weatherData;
    });
  }

  void handleStartTimerUpdate(status) {
    setState(() {
      timer = status;
    });
  }

  void handleHudToggle(hudData) {}

  void _setAltitude(double _altitude) {
    setState(() {
      altitude = _altitude;
    });
    bluetoothSend(conn, jsonEncode({"altitude": altitude}));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(OptionTab.title),
      ),
      drawer: widget.androidDrawer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: const Icon(Icons.bluetooth_connected, size: 64.0),
            ),
            Text(
              connectedDevice != null
                  ? ('Connected to ${connectedDevice?.name}')
                  : ('Not Connected'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10), // Column Padding
            ElevatedButton.icon(
                icon: const Icon(
                  // <-- Icon
                  Icons.device_hub_outlined,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DiscoveryPage()));

                  // if (status == SystemStatus.connected &&
                  //     connectedDevice != null) {
                  //   Navigator.push<void>(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               ChatPage(server: connectedDevice!)));
                  //   return;
                  // }
                },
                label: const Text('Connect to Glasses')),
            connectedDevice?.isConnected == true ? ElevatedButton.icon(
                icon: const Icon(
                  // <-- Icon
                  Icons.apps_outlined,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.push<void>(context,
                      MaterialPageRoute(builder: (context) => ControlPanel()));
                  return;
                },
                label: const Text('Control Glasses')) : SizedBox.shrink(),

            // ElevatedButton.icon(
            //     icon: const Icon(
            //       // <-- Icon
            //       Icons.sunny,
            //       size: 24.0,
            //     ),
            //     onPressed: () async {
            //       try {
            //         Map<String, dynamic> data = await fetchWeatherData();

            //         setState(() {
            //           weather = data;
            //         });
            //         // print(weather);
            //       } catch (e) {}
            //     },
            //     label: const Text('Get Weather')),
            ElevatedButton.icon(
                icon: const Icon(
                  // <-- Icon
                  Icons.sunny,
                  size: 24.0,
                ),
                onPressed: () async {
                  try {
                    double altitudeData = await fetchAltitudeData(context);
                    _setAltitude(altitudeData);

                    // Map<String, dynamic> data = await fetchWeatherData();

                    // setState(() {
                    //   weather = data;
                    // });
                    // print(weather);
                  } catch (e) {}
                },
                label: const Text('Get Altitude')),
            TimerButton(),
            WeatherFetcher(setWeather: handleWeatherUpdate),
            weather.isNotEmpty
                ? DisplayWeather(
                    setWeather: handleWeatherUpdate,
                    weatherJson: jsonEncode(weather))
                : SizedBox.shrink(),
            AltitudeWidget(altitude: altitude)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshData();
        },
        child: Icon(
          Icons.refresh,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: Colors.black,
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, /*RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: _itemsLength,
          itemBuilder: _listBuilder,
        ),
      ),*/
    );
  }

  @override
  Widget build(context) {
    return _buildAndroid(context);
  }
}

bool checkBluetoothStatus() {
  return true;
}
