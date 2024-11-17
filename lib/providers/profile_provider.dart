import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum AuthStatus { loading, success, error }

class ProfileProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AuthStatus _status = AuthStatus.success;
  User? _user;
  String _errorMessage = '';

  AuthStatus get status => _status;
  User? get user => _user;
  String get errorMessage => _errorMessage;

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    _setStatus(AuthStatus.loading);
    _errorMessage = ''; // Clear previous errors
    try {
      _user = await ApiService.getUserProfile();
      if (_user != null) {
        await _storage.write(
          key: 'userData',
          value: jsonEncode(_user!.toJson()),
        );
      }
      _setStatus(AuthStatus.success);
    } catch (error) {
      _errorMessage = '$error';
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> updateUserProfile(User updatedUser) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = ''; // Clear previous errors
    try {
      final response = await ApiService.updateUserProfile(updatedUser);
      if (response.statusCode == 200) {
        _user = updatedUser;
        await _storage.write(
          key: 'userData',
          value: jsonEncode(_user!.toJson()),
        );
        _setStatus(AuthStatus.success);
      } else {
        _errorMessage = 'Failed to update user profile';
        _setStatus(AuthStatus.error);
      }
    } catch (error) {
      _errorMessage = 'Error updating user profile: $error';
      _setStatus(AuthStatus.error);
    }
  }
}
