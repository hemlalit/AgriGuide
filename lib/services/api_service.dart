import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<User> getUserProfile() async {
    const storage = FlutterSecureStorage();
    final token =
        await storage.read(key: 'token'); // Use `await` to read the token
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } catch (e) {
        throw Exception('Failed to parse user profile');
      }
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<http.Response> updateUserProfile(User user) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('$baseUrl/profile/update'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'profile_image_url': user.profileImageUrl,
      }),
    );
    return response;
  }


}
