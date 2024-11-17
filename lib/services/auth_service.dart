import 'dart:convert';
import 'package:AgriGuide/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  // Change to your backend URL

  Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "phone": phone, "password": password}),
      );
      if (response.statusCode == 201) {
        return {'status': true, 'message': 'Registration successful'};
      } else {
        print('Error: ${response.body}');
        final responseData = jsonDecode(response.body);
        return {
          'status': false,
          'message': responseData['error'] 
        };
      }
    } catch (e) {
      print(e.toString());
      return {'status': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
          encoding: Encoding.getByName('utf-8'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Your auth token: $data['token']");
        await storage.write(key: 'token', value: data['token']);
        return {'status': true, 'message': 'Login successful'};
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'status': false,
          'message': responseData['error'] ?? 'Login failed'
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'status': false, 'message': 'Error connecting to server'};
    }
  }

// // Google Sign-In setup
//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         // Send googleUser.idToken to the backend for verification
//         print('Google User ID: ${googleUser.id}');
//       }
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//     }
//   }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}
