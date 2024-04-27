import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/models/fivedaysdata.dart';

class Forecast_Screen extends StatelessWidget {
  const Forecast_Screen({super.key, required this.forecastData});
  final Future<List<WeatherForecast>> forecastData;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          title: const Text(
            '5 Days Forecast',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<WeatherForecast>>(
          future: forecastData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              );
            } else if (snapshot.hasData) {
              final forecastFiveDay = snapshot.data!;
              return ListView.builder(
                itemCount: forecastFiveDay.isNotEmpty
                    ? 5
                    : 0, // Display up to 5 list tiles
                itemBuilder: (context, index) {
                  // Get the forecasts for the current day
                  List<DateTime> forecastsForDay = [];
                  double maxTemperature = double.negativeInfinity;
                  double minTemperature = double.infinity;
                  double windSpeed = 0;
                  String weatherMain = '';
                  // Extract the date for the current day
                  DateTime currentDate = DateTime.now()
                      .add(Duration(days: index + 1)); // Skip today
                  // Aggregate maximum and minimum temperatures, wind speed, and determine the main weather condition for the current day
                  for (var i = 0; i < forecastFiveDay.length; i++) {
                    var forecast = forecastFiveDay[i];
                    DateTime forecastDate = forecast.dtTxt;
                    // Check if the forecast date matches the current day and hasn't been displayed yet
                    if (forecastDate.year == currentDate.year &&
                        forecastDate.month == currentDate.month &&
                        forecastDate.day == currentDate.day &&
                        !forecastsForDay.contains(forecastDate)) {
                      forecastsForDay.add(forecastDate);
                      // Update maximum and minimum temperatures
                      if (forecast.main.tempMax != null &&
                          forecast.main.tempMax! > maxTemperature) {
                        maxTemperature = forecast.main.tempMax!;
                      }
                      if (forecast.main.tempMin != null &&
                          forecast.main.tempMin! < minTemperature) {
                        minTemperature = forecast.main.tempMin!;
                      }
                      windSpeed = forecast.wind.speed ?? 0;
                      if (forecast.weather.isNotEmpty) {
                        weatherMain = forecast.weather[0].main;
                      }
                    }
                  }
                  final formattedMaxTemperature =
                      (maxTemperature - 273.15).toInt();
                  final formattedMinTemperature =
                      (minTemperature - 273.15).toInt();
                  // Format the date to display
                  String formattedDate = DateFormat('EEEE').format(currentDate);
                  String imagePath = '';
                  switch (weatherMain) {
                    case 'Clear':
                      imagePath = 'lib/images/clear sky.png';
                      break;
                    case 'Clouds':
                      imagePath = 'lib/images/overcast clouds.png';
                      break;
                    case 'Rain':
                      imagePath = 'lib/images/rain.png';
                      break;
                    case 'Snow':
                      imagePath = 'lib/images/snow.png';
                      break;
                    // Add more cases for other weather conditions as needed
                    default:
                      imagePath =
                          'lib/images/unknown.png'; // Default image for unknown weather condition
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(imagePath),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '$formattedMaxTemperature',
                              style:
                                  const TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            const Text(
                              '°C',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              '/',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$formattedMinTemperature',
                              style:
                                  const TextStyle(fontSize: 22, color: Colors.grey),
                            ),
                            const Text(
                              '°C',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'lib/images/wind.png',
                            height: 30,
                            width: 30,
                          ),
                          Text(
                            '$windSpeed m/s',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              // Return something when none of the conditions match
              return const Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }
}
