import 'dart:convert';
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
