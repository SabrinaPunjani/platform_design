import 'dart:async';

import 'package:flutter/material.dart';
import 'package:platform_design/utils/api.dart';

class WeatherFetcher extends StatefulWidget {
  final setWeather;

  const WeatherFetcher({Key? key, this.setWeather}) : super(key: key);
  @override
  _WeatherFetcherState createState() => _WeatherFetcherState();
}

class _WeatherFetcherState extends State<WeatherFetcher> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(); // Fetch data on init
    _timer =
        Timer.periodic(Duration(minutes: 30), (timer) => _fetchWeatherData());
  }

  Future<void> _fetchWeatherData() async {
    Map<String, dynamic> weatherData = await fetchWeatherData();
    widget.setWeather(weatherData);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // empty widget
    // return Center(
    //   child: Text('Fetching weather data every hour...'),
    // );
  }
}
