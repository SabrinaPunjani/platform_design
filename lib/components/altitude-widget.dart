import 'package:flutter/material.dart';
import 'package:platform_design/utils/api.dart';

class AltitudeWidget extends StatelessWidget {
  final double altitude;
  final onRefresh;

  const AltitudeWidget(
      {Key? key, required this.altitude, required this.onRefresh})
      : super(key: key);

  handleAltitudeUpdate() async {
    onRefresh(await fetchAltitudeData());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Altitude display
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_upward,
                size: 30,
                color: Colors.blue,
              ),
              SizedBox(width: 8),
              Text(
                '${altitude.toStringAsFixed(2)} meters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Refresh button
        IconButton(
          icon: Icon(Icons.refresh),
          iconSize: 24,
          onPressed: handleAltitudeUpdate,
        ),
      ],
    );
  }
}
