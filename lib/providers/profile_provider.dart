import 'dart:convert';

import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum AuthStatus { loading, success, error, fetched }

class ProfileProvider with ChangeNotifier {
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

  Future<String> fetchUserProfile(BuildContext context) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = ''; // Clear previous errors
    try {
      Map<String, dynamic> data = await ApiService.getUserProfile();
      print(data['user']);
      _user = data['user'];
      print(_user);

      // Update the user data in secure storage
      String userData = jsonEncode(_user!.toJson());
      await updateUserData(context, 'userData', userData);

      _setStatus(AuthStatus.fetched);
      print(data['message']);
      return data['message'];
    } catch (error) {
      _errorMessage = '$error';
      print(_errorMessage);
      _setStatus(AuthStatus.error);
      return '';
    }
  }

  Future<String> fetchAnotherUserProfile(BuildContext context, String anotherUsersId,) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = ''; // Clear previous errors
    try {
      Map<String, dynamic> data = await ApiService.getAnotherUserProfile(anotherUsersId);
      print(data['user']);
      _user = data['user'];
      print(_user);

      // Update the user data in secure storage
      // String userData = jsonEncode(_user!.toJson());
      // await updateUserData(context, 'userData', userData);

      _setStatus(AuthStatus.fetched);
      print(data['message']);
      return jsonEncode(_user);
    } catch (error) {
      _errorMessage = '$error';
      print(_errorMessage);
      _setStatus(AuthStatus.error);
      return '';
    }
  }

  Future<void> updateUserProfile(BuildContext context, User updatedUser) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = ''; // Clear previous errors
    try {
      final response = await ApiService.updateUserProfile(updatedUser);
      if (response.statusCode == 200) {
        _user = updatedUser;
        
        // Update the user data in secure storage
        String userData = jsonEncode(_user!.toJson());
        await updateUserData(context, 'userData', userData);

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
