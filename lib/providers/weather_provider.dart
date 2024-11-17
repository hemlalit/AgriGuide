import 'package:AgriGuide/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:AgriGuide/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApiService _weatherApiService = WeatherApiService();

  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;

  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;

  Future<void> loadWeatherData(double lat, double lon) async {
    _setLoading(true);
    try {
      _weatherData = await _weatherApiService.fetchWeather(lat, lon);
    } catch (e) {
      MessageService.showSnackBar('Error fetching weather data');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
