import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const String _apiKey = 'dbfe1a100e694eed89b115807240111'; // Replace with your actual API key
  final String _baseUrl = 'https://api.weatherapi.com/v1/forecast.json';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = '$_baseUrl?key=$_apiKey&q=$lat,$lon&days=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> weatherJson = json.decode(response.body);
      return {
        'location': weatherJson['location']['name'] ?? 'Unknown',
        'temperature': weatherJson['current']['temp_c']?.toDouble() ?? 0.0,
        'humidity': weatherJson['current']['humidity']?.toInt() ?? 0,
        'rainPrediction': weatherJson['forecast']['forecastday'][0]['day']['daily_chance_of_rain']?.toDouble() ?? 0.0,
        'windSpeed': weatherJson['current']['wind_kph']?.toDouble() ?? 0.0,
        'uvIndex': weatherJson['current']['uv']?.toDouble() ?? 0.0,
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
