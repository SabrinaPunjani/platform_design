import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:math';

class BluetoothConnect extends StatefulWidget {
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  void _startScan() {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    flutterBlue.scan().listen((scanResult) {
      // if (!scanResult.device.name.isEmpty) {
      setState(() {
        scanResults.add(scanResult);
      });
      // }
    }, onDone: _stopScan);
  }

  void _stopScan() {
    setState(() {
      isScanning = false;
    });
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.link),
            Text("Connect to Device"),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: isScanning ? _stopScan : _startScan,
              child: Text(isScanning ? 'Stop Scan' : 'Start Scan'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                ScanResult result = scanResults[index];
                return ListTile(
                  title: Text(result.device.name.isEmpty
                      ? 'Unknown device'
                      : result.device.name),
                  subtitle: Text(result.device.id.toString()),
                  trailing: Text('${result.rssi} dBm'),
                  onTap: () {
                    result.device.connect();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class BluetoothConnect extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Find Devices'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () =>
//             FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               StreamBuilder<List<BluetoothDevice>>(
//                 stream: Stream.periodic(Duration(seconds: 2))
//                     .asyncMap((_) => FlutterBlue.instance.connectedDevices),
//                 initialData: [],
//                 builder: (c, snapshot) => Column(
//                   children: snapshot.data!
//                       .map((d) => ListTile(
//                             title: Text(d.name),
//                             subtitle: Text(d.id.toString()),
//                             trailing: StreamBuilder<BluetoothDeviceState>(
//                               stream: d.state,
//                               initialData: BluetoothDeviceState.disconnected,
//                               builder: (c, snapshot) {
//                                 if (snapshot.data ==
//                                     BluetoothDeviceState.connected) {
//                                   return ElevatedButton(
//                                     child: Text('OPEN'),
//                                     onPressed: () {},
//                                     // onPressed: () => Navigator.of(context).push(
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             DeviceScreen(device: d))),
//                                   );
//                                 }
//                                 return Text(snapshot.data.toString());
//                               },
//                             ),
//                           ))
//                       .toList(),
//                 ),
//               ),
//               // StreamBuilder<List<ScanResult>>(
//               //   stream: FlutterBlue.instance.scanResults,
//               //   initialData: [],
//               //   builder: (c, snapshot) => Column(
//               //     children: snapshot.data!
//               //         .map(
//               //           (r) => ScanResultTile(
//               //             result: r,
//               //             onTap: () => Navigator.of(context)
//               //                 .push(MaterialPageRoute(builder: (context) {
//               //               r.device.connect();
//               //               return DeviceScreen(device: r.device);
//               //             })),
//               //           ),
//               //         )
//               //         .toList(),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: FlutterBlue.instance.isScanning,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               child: Icon(Icons.stop),
//               onPressed: () => FlutterBlue.instance.stopScan(),
//               backgroundColor: Colors.red,
//             );
//           } else {
//             return FloatingActionButton(
//                 child: Icon(Icons.search),
//                 onPressed: () => FlutterBlue.instance
//                     .startScan(timeout: Duration(seconds: 50)));
//           }
//         },
//       ),
//     );
//   }
// }
