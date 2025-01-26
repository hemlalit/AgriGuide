import 'dart:convert';
import 'package:AgriGuide/utils/constants.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  Future<String> getChatbotResponse(String prompt) async {
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final candidates = jsonResponse['candidates'] as List;
      final text = candidates[0]['content']['parts'][0]['text'];
      return text;
    } else {
      print('Failed to get response from Gemini API');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to get response from Gemini API');
    }
  }
}
