import 'dart:convert';

import 'package:AgriGuide/models/weather_data.dart';
import 'package:AgriGuide/models/weather_data_current.dart';
import 'package:AgriGuide/models/weather_data_daily.dart';
import 'package:AgriGuide/models/weather_data_hourly.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:http/http.dart' as http;

class FetchWeather {
  WeatherData? weatherData;

  Future<WeatherData> proccessData(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherData(
        WeatherDataCurrent.fromJson(jsonString),
        WeatherDataHourly.fromJson(jsonString),
        WeatherDataDaily.fromJson(jsonString));

    return weatherData!;
  }

  String apiURL(var lat, var lon) {
    String url;

    url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric&exclude=minutely";
    return url;
  }
}
