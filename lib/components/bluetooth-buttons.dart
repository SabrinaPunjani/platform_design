import 'package:flutter/material.dart';

// DISCONNECT FROM DEVICE BUTTON
class DisconnectBtn extends StatefulWidget {
  final onDisconnect;
  const DisconnectBtn({Key? key, this.onDisconnect}) : super(key: key);

  @override
  _DisconnectBtnState createState() => _DisconnectBtnState();
}

class _DisconnectBtnState extends State<DisconnectBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: const Icon(
          // <-- Icon
          Icons.cancel,
          size: 24.0,
        ),
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => DiscoveryPage()));

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
        label: const Text('Disconnect From Glasses'));
  }
}
