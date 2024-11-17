import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WeatherInfoCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherInfoCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // Extract and format the local time
    String localtime = weatherData['localtime'] ?? '';
    DateTime apiTime;

    try {
      apiTime = DateTime.parse(localtime);
    } catch (e) {
      // Handle the case where the date parsing fails
      print('Error parsing date: $e');
      apiTime = DateTime.now(); // Fallback to current time
    }

    String formattedTime = DateFormat('MMM d, yyyy h:mm a').format(apiTime);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  weatherData['location'],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // FadeInImage.assetNetwork(
                //   placeholder: 'assets/loading.gif',
                //   image: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
                //   width: 50,
                //   height: 50,
                // ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${weatherData['temperature']} °C',
                        style: const TextStyle(fontSize: 40)),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Text('Humidity: ${weatherData['humidity']} %',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.cloudRain,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Text('${weatherData['rainPrediction']} %',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.wind,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text('Wind Speed: ${weatherData['windSpeed']} kph',
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.format_list_numbered_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text('UV Index: ${weatherData['uvIndex']}',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.clock,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(formattedTime,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
