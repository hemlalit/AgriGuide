import 'package:AgriGuide/controllers/weather_controller.dart';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/models/weather_data_hourly.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HourlyDataWeather extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;
  HourlyDataWeather({super.key, required this.weatherDataHourly});

  RxInt cardIndex = WeatherController().getIndex();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<WeatherSettingsProvider>(context).settings;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: Text(
            LocaleData.todayWeather.getString(context),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        hourlyList(settings, context),
      ],
    );
  }

  Widget hourlyList(WeatherSettings settings, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length > 12
            ? 12
            : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          return Obx(() => GestureDetector(
                onTap: () => cardIndex.value = index,
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.5, 0),
                        blurRadius: 30,
                        spreadRadius: 1,
                        color: isDarkMode
                            ? AppTheme.darkInputFill
                            : AppColors.dividerLine.withAlpha(150),
                      ),
                    ],
                    gradient: cardIndex.value == index
                        ? const LinearGradient(colors: [
                            AppColors.firstGradientColor,
                            AppColors.secondGradientColor,
                          ])
                        : null,
                  ),
                  child: HourlyDetails(
                    index: index,
                    cardIndex: cardIndex.toInt(),
                    temp: weatherDataHourly.hourly[index].temp!,
                    timestamp: weatherDataHourly.hourly[index].dt!,
                    weatherIcon:
                        weatherDataHourly.hourly[index].weather![0].icon!,
                    useCelsius: settings.useCelsius,
                  ),
                ),
              ));
        },
      ),
    );
  }
}

class HourlyDetails extends StatelessWidget {
  final int temp;
  final int index;
  final int cardIndex;
  final int timestamp;
  final String weatherIcon;
  final bool useCelsius;

  const HourlyDetails({
    super.key,
    required this.temp,
    required this.timestamp,
    required this.weatherIcon,
    required this.index,
    required this.cardIndex,
    required this.useCelsius,
  });

  String getTimestamp(final timestamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String x = DateFormat('jm').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    double displayedTemp = temp.toDouble();
    if (!useCelsius) {
      displayedTemp = (temp * 9 / 5) + 32; // Convert to Fahrenheit
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTimestamp(timestamp),
            style: TextStyle(
              color: isDarkMode
                  ? cardIndex == index
                      ? AppColors.textColorBlack
                      : Colors.white
                  : cardIndex == index
                      ? Colors.white
                      : AppColors.textColorBlack,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/weather/$weatherIcon.png",
            height: 40,
            width: 40,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            "${displayedTemp.toStringAsFixed(1)}°",
            style: TextStyle(
              color:isDarkMode
                  ? cardIndex == index
                      ? AppColors.textColorBlack
                      : Colors.white
                  : cardIndex == index
                      ? Colors.white
                      : AppColors.textColorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
