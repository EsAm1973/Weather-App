import 'package:weather_app/models/MainWeather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/wind.dart';

class WeatherForecast {
  int dt;
  Main main;
  List<Weather> weather;
  DateTime dtTxt;
  Wind wind;

  WeatherForecast({
    required this.dt,
    required this.main,
    required this.weather,
    required this.dtTxt,
    required this.wind,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      WeatherForecast(
        dt: json["dt"],
        main: Main.fromJson(json["main"]),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        dtTxt: DateTime.parse(json["dt_txt"]),
        wind: Wind.fromJson(json["wind"]),
      );
}
