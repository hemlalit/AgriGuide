
import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> getUserProfile() async {
    final String? token = await storage.read(key: 'token');

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
        return {
          "user": User.fromJson(data),
          "message": "Profile fetched succesfully"
        };
      } catch (e) {
        return {'err': 'Failed to parse user profile'};
      }
    } else {
      return {'err': 'Failed to load user profile'};
    }
  }

  static Future<Map<String, dynamic>> getAnotherUserProfile(String id) async {
    final String? token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$baseUrl/profile/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return {
          "user": User.fromJson(data),
          "message": "Profile fetched succesfully"
        };
      } catch (e) {
        return {'err': 'Failed to parse user profile'};
      }
    } else {
      return {'err': 'Failed to load user profile'};
    }
  }

  static Future<http.Response> updateUserProfile(User user) async {
    final String? token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('$baseUrl/profile/update'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        'name': user.name,
        'usernmae': user.username,
        'email': user.email,
        'phone': user.phone,
        'bio': user.bio,
        'bannerImage': user.bannerImage,
        'profileImage': user.profileImage,
      }),
    );
    return response;
  }

}
