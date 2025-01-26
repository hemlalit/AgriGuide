import 'dart:convert';
import 'package:AgriGuide/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  // Change to your backend URL

  Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    // String username = name.replaceAll(' ', '').toLowerCase();
    print("$name $email $phone");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password
        }),
      );
      if (response.statusCode == 201) {
        print(response.body);
        return {'status': true, 'message': 'Registration successful'};
      } else {
        print('Error: ${response.body}');
        final responseData = jsonDecode(response.body);
        return {'status': false, 'message': responseData['error']};
      }
    } catch (e) {
      print(e.toString());
      return {'status': false, 'message': 'Error connecting to server'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'userData', value: jsonEncode(data['user']));
        return {'status': true, 'message': 'Login successful'};
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'status': false,
          'message': responseData['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      print('hii Exception: $e');
      return {'status': false, 'message': 'Check your internet connection'};
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
    try {
      await storage.delete(key: 'token'); // Clear the token
      await storage.delete(key: 'userData'); // Clear the userData
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
