import 'package:AgriGuide/controllers/weather_controller.dart';
import 'package:AgriGuide/widgets/weather_widgets/current_weather.dart';
import 'package:AgriGuide/widgets/weather_widgets/daily_weather.dart';
import 'package:AgriGuide/widgets/weather_widgets/header.dart';
import 'package:AgriGuide/widgets/weather_widgets/hourly_weather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherController weatherController =
      Get.put(WeatherController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => weatherController.checkloading().isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(height: 20),
                      const headerWidget(),
                      CurrentWeather(
                        weatherDataCurrent:
                            weatherController.getData().getCurrentWeather(),
                      ),
                      const SizedBox(height: 20),
                      HourlyDataWeather(
                        weatherDataHourly:
                            weatherController.getData().getHourlyWeather(),
                      ),
                      DailyDataForecast(
                        weatherDataDaily:
                            weatherController.getData().getDailyForecast(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
