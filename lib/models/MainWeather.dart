class Main {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'] != null ? (json['temp'] as num).toDouble() : null,
      feelsLike: json['feels_like'] != null ? (json['feels_like'] as num).toDouble() : null,
      tempMin: json['temp_min'] != null ? (json['temp_min'] as num).toDouble() : null,
      tempMax: json['temp_max'] != null ? (json['temp_max'] as num).toDouble() : null,
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }
}
