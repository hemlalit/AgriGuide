import 'package:AgriGuide/controllers/weather_controller.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:AgriGuide/widgets/weather_widgets/current_weather.dart';
import 'package:AgriGuide/widgets/weather_widgets/daily_weather.dart';
import 'package:AgriGuide/widgets/weather_widgets/header.dart';
import 'package:AgriGuide/widgets/weather_widgets/hourly_weather.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherController weatherController =
      Get.put(WeatherController(), permanent: true);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await _showLocationServicesDialog();
      return;
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      await _showLocationPermissionsDeniedDialog();
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        await _showLocationPermissionsDeniedDialog();
      }
    }
  }

  Future<void> _showLocationServicesDialog() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? AppTheme.darkCardColor : Colors.white,
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLocationPermissionsDeniedDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permissions Denied'),
        content: const Text(
            'Location permissions are denied. Please enable location in your device settings to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => weatherController.checkloading().isTrue
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
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
                    const SizedBox(height: 20),
                    DailyDataForecast(
                      weatherDataDaily:
                          weatherController.getData().getDailyForecast(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
