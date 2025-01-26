import 'package:AgriGuide/models/weather_data_current.dart';
import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatefulWidget {
  final WeatherDataCurrent weatherDataCurrent;

  const CurrentWeather({super.key, required this.weatherDataCurrent});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  String? desc = '';

  void helper() async {
    String fromLanguage = 'en';
    final toLanguage = await storage.read(key: 'ln');
    String translatedDesc = await TranslationService().translateText(
        widget.weatherDataCurrent.current.weather![0].description,
        fromLanguage,
        toLanguage);
    setState(() {
      desc = translatedDesc;
    });
  }

  @override
  void initState() {
    helper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<WeatherSettingsProvider>(context).settings;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    double temperature = widget.weatherDataCurrent.current.temp!.toDouble();
    if (!settings.useCelsius) {
      temperature = (temperature * 9/5) + 32; // Convert to Fahrenheit
    }

    double windSpeed = widget.weatherDataCurrent.current.windSpeed!;
    if (!settings.useKmPerHour) {
      windSpeed = windSpeed / 3.6; // Convert to m/s
    }

    return Column(
      children: [
        temperatureWidget(temperature, isDarkMode),
        const SizedBox(height: 20),
        currentWeatherMoreDetailsWidget(windSpeed, isDarkMode, settings),
      ],
    );
  }

  Widget temperatureWidget(double temperature, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          "assets/weather/${widget.weatherDataCurrent.current.weather![0].icon}.png",
          height: 80,
          width: 80,
        ),
        Container(
          height: 50,
          width: 1,
          color: AppColors.dividerLine,
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "${temperature.toStringAsFixed(1)}°",
              style: TextStyle(
                fontSize: 68,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppTheme.darkText : AppTheme.lightText,
              ),
            ),
            TextSpan(
              text: desc,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget currentWeatherMoreDetailsWidget(double windSpeed, bool isDarkMode, dynamic settings) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            detailContainer(
                "assets/icons/windspeed.png",
                "${windSpeed.toStringAsFixed(2)} ${settings.useKmPerHour ? 'km/h' : 'm/s'}",
                isDarkMode),
            detailContainer("assets/icons/clouds.png",
                "${widget.weatherDataCurrent.current.clouds}%", isDarkMode),
            detailContainer("assets/icons/humidity.png",
                "${widget.weatherDataCurrent.current.humidity}%", isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget detailContainer(String iconPath, String value, bool isDarkMode) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? AppTheme.darkInputFill : AppColors.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(iconPath),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          width: 70,
          child: Text(
            value,
            style: TextStyle(
                fontSize: 12,
                color:
                    isDarkMode ? AppTheme.darkText : AppTheme.lightText),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
