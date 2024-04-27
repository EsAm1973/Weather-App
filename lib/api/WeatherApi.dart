import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_app/models/currentWeather.dart';
import 'package:weather_app/models/fivedaysdata.dart';

class Api {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = 'dce1390fc9d5c4aeaeb8a4168b9e580d';

  static Future<CurrentWeather> getWeatherData(String city) async {
    final finalUrl = '$baseUrl/weather?q=$city&appid=$apiKey';
    final Response response = await get(Uri.parse(finalUrl));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(response.body);
      return CurrentWeather.fromJson(jsonData);
    } else {
      throw Exception('Can not load weather data');
    }
  }

  static Future<List<WeatherForecast>> getWeatherForecast(String cityName) async {
    final url = Uri.parse('$baseUrl/forecast?q=$cityName&appid=$apiKey');
    final Response response = await get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['list'];
      print(response.body);
      return jsonData.map((data) => WeatherForecast.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
