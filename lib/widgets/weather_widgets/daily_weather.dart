import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/models/weather_data_daily.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/services/translator.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyDataForecast extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;
  const DailyDataForecast({super.key, required this.weatherDataDaily});

  @override
  State<DailyDataForecast> createState() => _DailyDataForecastState();
}

class _DailyDataForecastState extends State<DailyDataForecast> {
  List<String> translatedDays = [];

  @override
  void initState() {
    super.initState();
    _translateDays();
  }

  Future<void> _translateDays() async {
    List<String> days = widget.weatherDataDaily.daily.map((data) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(data.dt! * 1000);
      return DateFormat('EEEE').format(time);
    }).toList();

    String fromLanguage = 'en';
    final toLanguage =
        await storage.read(key: 'ln') ?? 'en'; // default to 'en' if null

    List<String> translated = [];
    for (String day in days) {
      String translatedDay = await TranslationService()
          .translateText(day, fromLanguage, toLanguage);
      translated.add(translatedDay);
    }

    setState(() {
      translatedDays = translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      height: 400,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkInputFill : AppColors.cardColor, // Updated
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              LocaleData.nextDays.getString(context),
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).textTheme.bodyMedium?.color, // Updated
              ),
            ),
          ),
          _dailyList(),
        ],
      ),
    );
  }

  Widget _dailyList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: widget.weatherDataDaily.daily.length > 7
            ? 7
            : widget.weatherDataDaily.daily.length,
        itemBuilder: (context, index) {
          final day = translatedDays.isNotEmpty ? translatedDays[index] : '...';

          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color, // Updated
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                          "assets/weather/${widget.weatherDataDaily.daily[index].weather![0].icon!}.png"),
                    ),
                    Text(
                      '${widget.weatherDataDaily.daily[index].temp!.min}° - ${widget.weatherDataDaily.daily[index].temp!.max}°',
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color, // Updated
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.dividerLine,
              ),
            ],
          );
        },
      ),
    );
  }
}
