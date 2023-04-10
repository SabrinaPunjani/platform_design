import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:platform_design/bluetooth/bluetooth-fns.dart';

import 'bluetooth-device-list-entry.dart';

// void getConnectedDevice() async {
//   List<BluetoothDevice> devices = [];
//   try {
//     devices = await FlutterBluetoothSerial.instance.getBondedDevices();
//   } catch (e) {
//     print(e);
//   }

//   // Assuming only one device is connected
//   BluetoothDevice device = devices[0];

//   // Get the currently connected device by calling `BluetoothConnection.toAddress()`
//   if (await device.isConnected) {
//     String connectedDeviceAddress = await device.address;
//     print(
//         'Connected to (${device.name}) with address: $connectedDeviceAddress');
//   } else {
//     print('Not currently connected to any device');
//   }
// }
// import './BluetoothDeviceListEntry.dart';

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  final onConnect;
  const DiscoveryPage({this.start = true, this.onConnect});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isScanning = false;

  _DiscoveryPage();

  @override
  initState() {
    super.initState();
    // getConnectedDevice();

    isScanning = widget.start;
    if (isScanning) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isScanning = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);

        if (existingIndex >= 0)
          results[existingIndex] = r;
        else if (r.device.name != null && !r.device.name!.isEmpty) {
          results.add(r);
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to Device"),
        actions: <Widget>[
          isScanning
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(value: null),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          final device = result.device;
          final address = device.address;
          return BluetoothDeviceListEntry(
            device: device,
            rssi: result.rssi,
            onTap: () async {
              try {
                print(
                    "${device.name}: bonded? ${device.isBonded}, connected? ${device.isConnected}");
                // connectToDevice(address);

                // bonded means it has previously connected to the device, but is
                // not currently connected.

                if (!device.isBonded) {
                  bool bonded = (await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(address))!;
                }

                if (!device.isConnected) {
                  BluetoothConnection.toAddress(device.address).then((conn) {
                    // print(conn);
                    if (conn.isConnected) {
                      widget.onConnect(device, conn);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                'Now Connected to "${result.device.name}"'),
                            // content: Text("P"),
                            actions: <Widget>[
                              new TextButton(
                                child: new Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                  // BluetoothConnection conn =
                  //     await BluetoothConnection.toAddress(device.address);
                }

                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return ChatPage(server: device);
                // }));
                // else try to. send data

                // BluetoothConnection.toAddress(address).then((conn) => {
                //   conn.
                // })
              } catch (ex) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text('Unable to connect to "${result.device.name}"'),
                      content: Text("${ex.toString()}"),
                      actions: <Widget>[
                        new TextButton(
                          child: new Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }

              // Navigator.of(context).pop(result.device);

              // Navigator.of(context).pop();
            },
            onLongPress: () async {
              try {
                bool bonded = false;
                if (device.isBonded) {
                  print('Unbonding from ${device.address}...');
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(address);
                  print('Unbonding from ${device.address} has succed');
                } else {
                  print('Bonding with ${device.address}...');
                  bonded = (await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(address))!;
                  print(
                      'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                }
                setState(() {
                  results[results.indexOf(result)] = BluetoothDiscoveryResult(
                      device: BluetoothDevice(
                        name: device.name ?? '',
                        address: address,
                        type: device.type,
                        bondState: bonded
                            ? BluetoothBondState.bonded
                            : BluetoothBondState.none,
                      ),
                      rssi: result.rssi);
                });
              } catch (ex) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error occured while bonding'),
                      content: Text("${ex.toString()}"),
                      actions: <Widget>[
                        new TextButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
