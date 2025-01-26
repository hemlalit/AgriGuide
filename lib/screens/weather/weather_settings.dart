import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherSettingsScreen extends StatefulWidget {
  const WeatherSettingsScreen({super.key});

  @override
  State<WeatherSettingsScreen> createState() => _WeatherSettingsScreenState();
}

class _WeatherSettingsScreenState extends State<WeatherSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final weatherSettingsProvider = Provider.of<WeatherSettingsProvider>(context);
    final settings = weatherSettingsProvider.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Use Celsius'),
              subtitle: const Text('Switch between Celsius and Fahrenheit'),
              value: settings.useCelsius,
              onChanged: (value) {
                weatherSettingsProvider.toggleUnit();
              },
            ),
            SwitchListTile(
              title: const Text('Use km/h'),
              subtitle: const Text('Switch between km/h and m/s for wind speed'),
              value: settings.useKmPerHour,
              onChanged: (value) {
                weatherSettingsProvider.toggleSpeedUnit();
              },
            ),
            ListTile(
              title: const Text('Refresh Interval'),
              subtitle: const Text('Set the interval for weather updates'),
              trailing: DropdownButton<Duration>(
                value: settings.refreshInterval,
                onChanged: (Duration? newValue) {
                  if (newValue != null) {
                    weatherSettingsProvider.setRefreshInterval(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: Duration(minutes: 15),
                    child: Text('15 minutes'),
                  ),
                  DropdownMenuItem(
                    value: Duration(minutes: 30),
                    child: Text('30 minutes'),
                  ),
                  DropdownMenuItem(
                    value: Duration(hours: 1),
                    child: Text('1 hour'),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive weather updates notifications'),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                weatherSettingsProvider.toggleNotifications();
              },
            )
          ],
        ),
      ),
    );
  }
}
