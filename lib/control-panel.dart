import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:platform_design/components/timer-button.dart';

class ControlPanel extends StatefulWidget {
  final BluetoothConnection? conn;
  final String? weather;

  const ControlPanel({Key? key, this.conn, this.weather}) : super(key: key);
  // const ControlPanel({required this.server});
  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Control Panel"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              TimerButton(),
            ],
          ),
        ));
  }
}
