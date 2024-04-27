import 'package:intl/intl.dart';
import 'package:weather_app/models/MainWeather.dart';
import 'package:weather_app/models/clouds.dart';
import 'package:weather_app/models/coord.dart';
import 'package:weather_app/models/sys.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/wind.dart';

class CurrentWeather {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  CurrentWeather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      coord: Coord.fromJson(json['coord']),
      weather:
          List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
      base: json['base'],
      main: Main.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
  String getFormattedDate() {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true).toLocal();
    final formattedDate = DateFormat('EEEE d, MMM').format(dateTime);
    return formattedDate;
  }

  
}
