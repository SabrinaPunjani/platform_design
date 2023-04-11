import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:platform_design/utils/api.dart';

// class DisplayWeather extends StatefulWidget {
//   const DisplayWeather({Key? key}) : super(key: key);

//   @override
//   _DisplayWeatherState createState() => _DisplayWeatherState();
// }

// class _DisplayWeatherState extends State<DisplayWeather> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class DisplayWeather extends StatelessWidget {
  final String weatherJson;
  final setWeather;

  DisplayWeather({required this.setWeather, required this.weatherJson});

  void onRefresh() {
    fetchWeatherData().then((weatherData) => setWeather(weatherData));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> weatherData = jsonDecode(weatherJson);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${weatherData['phrase']}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Icon(Icons.thermostat),
                  SizedBox(width: 8),
                  Text(
                    'Temp: ${weatherData['temperature']['value']}°${weatherData['temperature']['unit']} (Feels like ${weatherData['realFeelTemperature']['value']}°${weatherData['realFeelTemperature']['unit']})',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Icon(Icons.water),
                  SizedBox(width: 8),
                  Text(
                    'Humidity: ${weatherData['relativeHumidity']}%',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Icon(Icons.air),
                  SizedBox(width: 8),
                  Text(
                    'Wind: ${weatherData['wind']['direction']['localizedDescription']} ${weatherData['wind']['speed']['value']} ${weatherData['wind']['speed']['unit']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ),
      ],
    );
  }
}
