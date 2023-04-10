import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Map<String, dynamic> template = {
  "timer": null,
  "weather": null,
  "hud_toggles": null,
  "altitude": null, // number in meters
};
// Returns the connected device.
Future<BluetoothDevice?> getConnectedDevice() async {
  List<BluetoothDevice> devices = [];

  try {
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  } catch (e) {
    print(e);
  }

  BluetoothDevice device = devices[0];

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
    var packet = jsonEncode({
      ...template,
      ...jsonDecode(txt),
    });

    print("[Bluetooth Comm] Sending packet = $packet");
    if (connection == null) {
      print("[Bluetooth Comm] Connection not established");
      return false;
    }
    connection.output.add(Uint8List.fromList(utf8.encode(packet)));
    await connection.output.allSent;
    print("[Bluetooth Comm] Sent message");
    return true;
  } catch (e) {
    print("[Bluetooth Comm] Error sending message");
    return false;
  }
}

Future<bool?> disconnectFromDevice(BluetoothDevice btDevice) async {
  final status = await FlutterBluetoothSerial.instance
      .removeDeviceBondWithAddress(btDevice.address);
  return status;
}

Future<bool?> connectToDevice(String address) async {
  try {
    bool bonded =
        (await FlutterBluetoothSerial.instance.bondDeviceAtAddress(address))!;
    return bonded;
  } catch (e) {
    return false;
  }

  // print('Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
}
