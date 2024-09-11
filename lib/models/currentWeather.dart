import 'package:intl/intl.dart';
import 'package:weather_app/models/MainWeather.dart';
import 'package:weather_app/models/weather.dart';

class CurrentWeather {
  final List<Weather> weather;
  final Main main;
  final int dt;
  final String name;

  CurrentWeather({
    required this.weather,
    required this.main,
    required this.dt,
    required this.name,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      weather:
          List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
      main: Main.fromJson(json['main']),
      dt: json['dt'],
      name: json['name'],
    );
  }
  String getFormattedDate() {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true).toLocal();
    final formattedDate = DateFormat('EEEE d, MMM').format(dateTime);
    return formattedDate;
  }
}
