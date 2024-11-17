import 'package:AgriGuide/services/location_service.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:AgriGuide/widgets/weather_info_card.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late LocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _fetchWeather();
  }

  void _fetchWeather() async {
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      await Provider.of<WeatherProvider>(context, listen: false)
          .loadWeatherData(locationData.latitude, locationData.longitude);
    } else {
      MessageService.showSnackBar('Cannot get location now');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: Center(
        child: weatherProvider.isLoading
            ? const CircularProgressIndicator()
            : weatherProvider.weatherData == null
                ? const Text('No weather data available')
                : AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: WeatherInfoCard(weatherData: weatherProvider.weatherData!),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
