import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_design/utils/keys.dart';

String clientId = 'YOUR_CLIENT_ID';
String clientSecret = 'YOUR_CLIENT_SECRET';
String redirectUri = 'YOUR_REDIRECT_URI';

Future<Map<String, dynamic>> fetchWeatherData() async {
  print("Getting weather...");

  // Request location permission
  PermissionStatus permission = await Permission.locationWhenInUse.request();

  if (permission.isGranted) {
    // print("is granted");
    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Set the API endpoint

    print("${position.latitude},${position.longitude}");
    String apiUrl =
        "https://atlas.microsoft.com/weather/currentConditions/json?api-version=1.1&subscription-key=$subscriptionKey&query=${position.latitude},${position.longitude}";

    // Send the HTTP request
    final response = await http.get(Uri.parse(apiUrl));
    // print(response.statusCode);
    // Check if the request was successful
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body)["results"][0];
      // print(results);
      // print(body.toString());
      final data = {
        "dateTime": results["dateTime"],
        "phrase": results["phrase"],
        "iconCode": results["iconCode"],
        "hasPrecipitation": results["hasPrecipitation"],
        "isDayTime": results["isDayTime"],
        "temperature": results["temperature"],
        "realFeelTemperature": results["realFeelTemperature"],
        "relativeHumidity": results["relativeHumidity"],
        "wind": results["wind"],
      };
      print("[Weather] Data fetched: $data");
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  } else {
    throw Exception('Location permission not granted');
  }
}

Future<double> fetchAltitudeData(BuildContext context) async {
  print("Fetching Altitude Data...");

  // Check for location permission
  PermissionStatus permissionStatus = await Permission.location.request();

  if (permissionStatus.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Build the Elevation API URL
    String apiUrl =
        'https://atlas.microsoft.com/elevation/point/json?api-version=1.0&subscription-key=$subscriptionKey&points=$longitude,$latitude';

    // Fetch altitude data from Azure Maps Elevation API
    final response = await http.get(Uri.parse(apiUrl));
    print(response.statusCode);
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      double altitude = jsonResponse["data"][0]['elevationInMeter'];

      return altitude;

    } else {
      throw Exception('Failed to load altitude data');
    }
  } else {
      throw Exception('Location permission not granted');
  }
}