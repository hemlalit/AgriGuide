import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:AgriGuide/models/news_model.dart';
import 'package:AgriGuide/models/scheme_model.dart';

class FeedsService {
  static const String _baseUrl = 'https://api.example.com';

  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse('$_baseUrl/news'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<List<Scheme>> fetchSchemes() async {
    final response = await http.get(Uri.parse('$_baseUrl/schemes'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Scheme.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schemes');
    }
  }
}
