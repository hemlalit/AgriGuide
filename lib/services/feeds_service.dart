import 'dart:convert';
import 'package:AgriGuide/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:AgriGuide/models/feeds_model.dart';

class FeedsService {
  // static const String _baseUrl = 'https://api.example.com';

  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse('$baseUrl/news'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<List<News>> fetchSchemes() async {
    final response = await http.get(Uri.parse('$baseUrl/schemes'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schemes');
    }
  }
}
