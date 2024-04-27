import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/WeatherApi.dart';
import 'package:weather_app/models/currentWeather.dart';
import 'package:weather_app/models/fivedaysdata.dart';
import 'package:weather_app/screens/ForecastScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = 'Zagazig';
  TextEditingController editingCity = TextEditingController();

  late Future<CurrentWeather> _weatherData;
  late Future<List<WeatherForecast>> _forecast;
  @override
  void initState() {
    super.initState();
    _weatherData = Api.getWeatherData(city);
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    setState(() {
      _forecast = Api.getWeatherForecast(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                TextField(
                  controller: editingCity,
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      city = editingCity.text;
                      _weatherData = Api.getWeatherData(city);
                      _fetchForecast();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by City',
                    labelText: 'City',
                    suffixIcon: const Icon(Icons.search),
                    suffixIconColor: Colors.white,
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),

                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                const SizedBox(
                  height: 40,
                ),
                FutureBuilder<CurrentWeather?>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasData) {
                      final weatherData = snapshot.data!;
                      final temperature = weatherData.main.temp;
                      final formattedTemperature = temperature != null
                          ? (temperature - 273.15).toInt()
                          : 'N/A';
                      final description = weatherData.weather.isNotEmpty
                          ? weatherData.weather[0].description
                          : 'No description available';
                      final main = weatherData.weather.isNotEmpty
                          ? weatherData.weather[0].main
                          : 'No description available';
                      String imagePath = '';
                      if (description == 'clear sky') {
                        imagePath = 'lib/images/clear sky.png';
                      } else if (description == 'few clouds') {
                        imagePath = 'lib/images/few clouds.png';
                      } else if (description == 'scattered clouds') {
                        imagePath = 'lib/images/scattered clouds.png';
                      } else if (description == 'broken clouds') {
                        imagePath = 'lib/images/broken clouds.png';
                      } else if (description == 'overcast clouds') {
                        imagePath = 'lib/images/overcast clouds.png';
                      } else if (description == 'light rain') {
                        imagePath = 'lib/images/light rain.png';
                      } else if (description == 'shower rain') {
                        imagePath = 'lib/images/shower rain.png';
                      } else if (description == 'thunderstorm') {
                        imagePath = 'lib/images/thunderstorm.png';
                      } else if (description == 'snow') {
                        imagePath = 'lib/images/snow.png';
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade900,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Now',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white)),
                                Row(
                                  children: [
                                    Text(
                                      '$formattedTemperature',
                                      style: const TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const Text(
                                      '°C',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      imagePath,
                                      height: 100,
                                      width: 170,
                                    ),
                                  ],
                                ),
                                Text(
                                  description,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                const Divider(
                                  thickness: 0.2,
                                ),
                                Text(
                                  'Date: ${weatherData.getFormattedDate()}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'City: ${weatherData.name}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Forecast_Screen(
                                          forecastData: _forecast)));
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      'Forecast',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<List<WeatherForecast>>(
                            future: _forecast,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else if (snapshot.hasData) {
                                final forecastData = snapshot.data!;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade900,
                                  ),
                                  child: SizedBox(
                                    height:
                                        230, // Set a specific height or use Expanded
                                    child: ListView.builder(
                                      itemCount: forecastData.length,
                                      itemBuilder: (context, index) {
                                        // Get the forecast for the current index
                                        final forecast = forecastData[index];
                                        // Extract the date from the forecast
                                        DateTime forecastDate = forecast.dtTxt;
                                        // Get today's date
                                        DateTime today = DateTime.now();
                                        // Check if the forecast date is today
                                        if (forecastDate.year == today.year &&
                                            forecastDate.month == today.month &&
                                            forecastDate.day == today.day) {
                                          // Forecast date is today, display the data
                                          var dtTxt = DateFormat('kk:mm')
                                              .format(forecastDate);
                                          final temperature =
                                              forecast.main.temp;
                                          final formattedTemperature =
                                              temperature != null
                                                  ? (temperature - 273.15)
                                                      .toInt()
                                                  : 'N/A';
                                          final description = forecast
                                                  .weather.isNotEmpty
                                              ? forecast.weather[0].description
                                              : 'No description available';
                                          final main =
                                              forecast.weather.isNotEmpty
                                                  ? forecast.weather[0].main
                                                  : 'No description available';
                                          final wind = forecast.wind.speed;
                                          String imagePath = '';
                                          if (description == 'clear sky') {
                                            imagePath =
                                                'lib/images/clear sky.png';
                                          } else if (description ==
                                              'few clouds') {
                                            imagePath =
                                                'lib/images/few clouds.png';
                                          } else if (description ==
                                              'scattered clouds') {
                                            imagePath =
                                                'lib/images/scattered clouds.png';
                                          } else if (description ==
                                              'broken clouds') {
                                            imagePath =
                                                'lib/images/broken clouds.png';
                                          } else if (description ==
                                              'overcast clouds') {
                                            imagePath =
                                                'lib/images/overcast clouds.png';
                                          } else if (description ==
                                              'light rain') {
                                            imagePath =
                                                'lib/images/light rain.png';
                                          } else if (description ==
                                              'shower rain') {
                                            imagePath =
                                                'lib/images/shower rain.png';
                                          } else if (description ==
                                              'thunderstorm') {
                                            imagePath =
                                                'lib/images/thunderstorm.png';
                                          } else if (description == 'snow') {
                                            imagePath = 'lib/images/snow.png';
                                          }
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                imagePath,
                                                height: 50,
                                                width: 50,
                                              ),
                                              Text(
                                                '$formattedTemperature°C',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                dtTxt,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Image.asset(
                                                    'lib/images/wind.png',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    '$wind m/s',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        } else {
                                          // Forecast date is not today, return an empty container
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                // Return something when none of the conditions match
                                return const Text(
                                  'No data available',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          )
                        ],
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
