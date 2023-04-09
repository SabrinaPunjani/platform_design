import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Map<String, dynamic> template = {
  "timer": null,
  "weather": null,
  "hud_toggles": null,
};
// Returns the connected device.
Future<BluetoothDevice?> getConnectedDevice() async {
  List<BluetoothDevice> devices = [];

  try {
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  } catch (e) {
    print(e);
  }

  // Assuming only one device is connected
  BluetoothDevice device = devices[0];

  // Get the currently connected device by calling `BluetoothConnection.toAddress()`

  if (device.isConnected) {
    return device;
  } else {
    return null;
  }
  // if (await device.isConnected) {
  //   String connectedDeviceAddress = await device.address;
  //   print(
  //       'Connected to (${device.name}) with address: $connectedDeviceAddress');
  // } else {
  //   print('Not currently connected to any device');
  // }
}

Future<bool> bluetoothSend(BluetoothConnection? connection, String txt) async {
  try {
    var packet = {
      ...template,
      ...jsonDecode(txt),
    };

    print("[Bluetooth Comm]: Sending packet = $packet");
    if (connection == null) {
      print("[Bluetooth Comm] Connection not established");
      return false;
    }
    connection.output.add(Uint8List.fromList(utf8.encode(txt)));
    await connection.output.allSent;
    print("[Bluetooth Comm] Sent message");
    return true;
  } catch (e) {
    print("[Bluetooth Comm] Error sending message");
    return false;
  }
}
