import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/services/facebook_auth_service.dart';
import 'package:AgriGuide/services/google_auth_service.dart';
import 'package:AgriGuide/services/insta_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider with ChangeNotifier {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final FacebookAuthService _facebookAuthService = FacebookAuthService();
  final InstagramAuthService _instagramAuthService = InstagramAuthService();
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthStatus _status = AuthStatus.idle;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _errorMessage = '';
  String _message = '';
  User? _user;

  AuthStatus get status => _status;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get message => _message;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    String? token = await _storage.read(key: 'token');
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    notifyListeners();
    final response = await _authService.login(email, password);
    _isLoading = false;

    if (response['status']) {
      _message = response['message'];
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _errorMessage = response['message'];
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<bool> register(
      String name, String email, String phone, String password) async {
    _setStatus(AuthStatus.loading);
    notifyListeners();
    final response = await _authService.register(name, email, phone, password);
    _isLoading = false;
    if (response['status']) {
      _message = response['message'];
      return true;
    } else {
      _errorMessage = response['message'];
      notifyListeners();
      return false;
    }
  }

  Future<void> loginWithGoogle() async {
    _setStatus(AuthStatus.loading);
    try {
      await _googleAuthService.signInWithGoogle();
      _setStatus(AuthStatus.success);
    } catch (e) {
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> loginWithFacebook() async {
    _setStatus(AuthStatus.loading);
    try {
      await _facebookAuthService.signInWithFacebook();
      _setStatus(AuthStatus.success);
    } catch (e) {
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> loginWithInstagram(BuildContext context) async {
    _setStatus(AuthStatus.loading);
    try {
      _instagramAuthService.signInWithInstagram(context);
      _setStatus(AuthStatus.success);
    } catch (e) {
      _setStatus(AuthStatus.error);
    }
  }

  // Future<void> fetchUserProfile() async {
  //   const storage = FlutterSecureStorage();
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _user = await ApiService.getUserProfile();
  //     if (_user != null) {
  //       await storage.write(
  //           key: 'userData',
  //           value: jsonEncode(_user!.toJson())); // Serialize the user object
  //     }
  //   } catch (error) {
  //     print('Error fetching user profile: $error');
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> updateUserProfile(User updatedUser) async {
  //   _setStatus(AuthStatus.loading);
  //   notifyListeners();
  //   try {
  //     final response = await ApiService.updateUserProfile(updatedUser);
  //     if (response.statusCode == 200) {
  //       _user = updatedUser;
  //       _setStatus(AuthStatus.success);
  //     } else {
  //       throw Exception('Failed to update user profile');
  //     }
  //   } catch (error) {
  //     print('Error updating user profile: $error');
  //     _setStatus(AuthStatus.error);
  //   }
  //   notifyListeners();
  // }

  Future<void> logout() async {
    _setStatus(AuthStatus.loading);
    await _authService.logout();
    await _storage.delete(key: 'token'); // Clear the token
    _isAuthenticated = false;
    notifyListeners();
  }
}
