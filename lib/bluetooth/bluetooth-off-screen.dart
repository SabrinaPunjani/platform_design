import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: const [
          Icon(Icons.bluetooth_disabled),
          Text('Bluetooth is Off'),
        ],
      ),
    );
  }
}
