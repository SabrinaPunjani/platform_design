import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class TimerButton extends StatefulWidget {
  final BluetoothDevice? server;
  final onTimerUpdate;

  const TimerButton({this.server, this.onTimerUpdate});

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  bool _timerActive = false;
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  Duration _elapsedTime = Duration();

  void _toggleTimer() {
    setState(() {
      _timerActive = !_timerActive;

      if (_timerActive) {
        _stopwatch.start();
        _startTimer();
        widget.onTimerUpdate('start');
      } else {
        _stopwatch.stop();
        _timer.cancel();
        widget.onTimerUpdate('stop');
      }
    });

    // Map<String, dynamic> jsonMessage = {
    //   'timer': _timerActive,
    // };
    // print(json.encode(jsonMessage));
  }

  void _resetTimer() {
    setState(() {
      if (_timerActive) {
        setState(() {
          _timerActive = false;
        });
      }

      _stopwatch.stop();
      _timer.cancel();
      _stopwatch.reset();
      _elapsedTime = Duration();
      widget.onTimerUpdate('reset');
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  icon: _timerActive
                      ? const Icon(
                          Icons.pause,
                          size: 24.0,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 24.0,
                        ),
                  onPressed: _toggleTimer,
                  label: Text(_timerActive ? 'Stop Timer' : 'Start Timer'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Icon(Icons.refresh),
                  // style: ElevatedButton.styleFrom(
                  //   shape: CircleBorder(),
                  //   padding: EdgeInsets.all(12),
                  // ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        '${_elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}.',
                  ),
                  TextSpan(
                    text:
                        '${(_elapsedTime.inMilliseconds % 1000).toString().padLeft(3, '0')}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Add other widgets if needed
      ],
    );
  }
}
