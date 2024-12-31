import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CropApiService {
  static const String _baseUrl = 'http://localhost:3000/api/crop';

  static Future<String> analyzeCropImage(File image) async {
    final uri = Uri.parse('$_baseUrl/analyze');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      return data['result'];
    } else {
      throw Exception('Failed to analyze image');
    }
  }
}
