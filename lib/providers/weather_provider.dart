import 'package:flutter/material.dart';

class WeatherSettings {
  bool useCelsius;
  bool useKmPerHour;
  Duration refreshInterval;
  bool notificationsEnabled;

  WeatherSettings({
    required this.useCelsius,
    required this.useKmPerHour,
    required this.refreshInterval,
    required this.notificationsEnabled,
  });
}

class WeatherSettingsProvider with ChangeNotifier {
  WeatherSettings _settings = WeatherSettings(
    useCelsius: true,
    useKmPerHour: true,
    refreshInterval: const Duration(minutes: 30),
    notificationsEnabled: true,
  );

  WeatherSettings get settings => _settings;

  void toggleUnit() {
    _settings.useCelsius = !_settings.useCelsius;
    notifyListeners();
  }

  void toggleSpeedUnit() {
    _settings.useKmPerHour = !_settings.useKmPerHour;
    notifyListeners();
  }

  void setRefreshInterval(Duration interval) {
    _settings.refreshInterval = interval;
    notifyListeners();
  }

  void toggleNotifications() {
    _settings.notificationsEnabled = !_settings.notificationsEnabled;
    notifyListeners();
  }
}
