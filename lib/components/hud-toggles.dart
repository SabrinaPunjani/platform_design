


// import 'package:flutter/material.dart';

// class HudToggleWidget extends StatefulWidget {
//   @override
//   _HudToggleWidgetState createState() => _HudToggleWidgetState();
// }

// class _HudToggleWidgetState extends State<HudToggleWidget> {
//   Map<String, bool> hudToggles = {
//     "weather": false,
//     "biometrics": false,
//     "blindspot": false,
//     "bike_stats": false,
//     "timer": false,
//     "altitude": false,
//   };

//   void _updateToggle(String key, bool value) {
//     setState(() {
//       hudToggles[key] = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: hudToggles.keys.map<Widget>((key) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(key),
//             Switch(
//               value: hudToggles[key]!,
//               onChanged: (value) => _updateToggle(key, value),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HudToggles extends StatefulWidget {
  final Map<String, bool> hudToggles;
  final Function(String, bool) onToggle;

  HudToggles({required this.hudToggles, required this.onToggle});

  @override
  _HudTogglesState createState() => _HudTogglesState();
}

class _HudTogglesState extends State<HudToggles> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the number of switches per row
        int switchesPerRow = constraints.maxWidth ~/ 150;

        // Create a list of widgets to add in the Wrap widget
        List<Widget> switches = [];

        widget.hudToggles.forEach((key, value) {
          switches.add(
            Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key),
                  Switch(
                    value: value,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.hudToggles[key] = newValue;
                      });
                      widget.onToggle(key, newValue);
                    },
                  ),
                ],
              ),
            ),
          );
        });

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: switches,
        );
      },
    );
  }
}