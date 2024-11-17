import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class FacebookAuthService {
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        if (accessToken == null) {
          print('Access token is null');
          return;
        }

        // Send the token to the backend
        final response = await http.post(
          Uri.parse('http://localhost:5000/auth/facebook'),
          body: {'token': accessToken},
        );

        print('Backend Response: ${response.body}');
      } else {
        print('Facebook Sign-In Error: ${result.status}');
      }
    } catch (e) {
      print('Facebook Sign-In Error: $e');
    }
  }
}
