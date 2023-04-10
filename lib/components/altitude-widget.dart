import 'package:flutter/material.dart';

class AltitudeWidget extends StatelessWidget {
  final double altitude;

  const AltitudeWidget({Key? key, required this.altitude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_upward,
          size: 20,
          color: Colors.blue,
        ),
        SizedBox(width: 8),
        Text(
          '${altitude.toStringAsFixed(2)} meters',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}