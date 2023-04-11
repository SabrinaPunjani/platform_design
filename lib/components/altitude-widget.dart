import 'dart:async';
import 'package:flutter/material.dart';
import 'package:platform_design/utils/api.dart';

class AltitudeWidget extends StatefulWidget {
  final double altitude;
  final onRefresh;

  const AltitudeWidget(
      {Key? key, required this.altitude, required this.onRefresh})
      : super(key: key);

  @override
  _AltitudeWidgetState createState() => _AltitudeWidgetState();
}

class _AltitudeWidgetState extends State<AltitudeWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      widget.onRefresh(await fetchAltitudeData());
    });
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
                '${widget.altitude.toStringAsFixed(2)} meters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Refresh button
        // IconButton(
        //   icon: Icon(Icons.refresh),
        //   iconSize: 24,
        //   onPressed: handleAltitudeUpdate,
        // ),
      ],
    );
  }
}
