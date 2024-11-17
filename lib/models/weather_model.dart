class Weather {
  final String location;
  final double temperature;
  final int humidity;
  final double soilSalinity;
  final int rainPrediction;

  Weather({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.soilSalinity,
    required this.rainPrediction,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location'] ?? 'Unknown',
      temperature: json['temperature']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toInt() ?? 0,
      soilSalinity: json['soilSalinity']?.toDouble() ?? 0.0,
      rainPrediction: json['rainPrediction']?.toInt() ?? 0,
    );
  }
}
