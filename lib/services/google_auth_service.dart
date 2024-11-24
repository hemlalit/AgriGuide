import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final idToken = googleAuth.idToken;

        // Send the token to the backend
        final response = await http.post(
          Uri.parse('http://localhost:5000/auth/google'),
          body: {'token': idToken},
        );

        print('Backend Response: ${response.body}');
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }
}
