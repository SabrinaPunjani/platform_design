import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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
