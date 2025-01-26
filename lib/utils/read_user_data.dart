import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:AgriGuide/providers/profile_provider.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

final storage = const FlutterSecureStorage();

Future<void> updateUserData(
    BuildContext context, String key, String value) async {
  try {
    await storage.write(key: key, value: value);
  } catch (e) {
    MessageService.showSnackBar('Error updating user data');
  }
}

Future<Map<String, dynamic>?> readAnotherUserData(
    BuildContext context, String anotherUsersId) async {
  final provider = Provider.of<ProfileProvider>(context, listen: false);
  try {
    final userData =
        await provider.fetchAnotherUserProfile(context, anotherUsersId);
    // After fetching the user profile, update the local storage
    // String userData = jsonEncode(provider.user!.toJson()); // Use toJson
    // await updateUserData(context, 'anotherUserData', userData);
    return jsonDecode(userData);
  } catch (e) {
    print(e);
    MessageService.showSnackBar('Error fetching user data - $e');
  }
  // final String? userData = await storage.read(key: 'userData');
}

Future<Map<String, dynamic>?> readUserData(BuildContext context) async {
  final provider = Provider.of<ProfileProvider>(context, listen: false);
  try {
    await provider.fetchUserProfile(context);
    // After fetching the user profile, update the local storage
    String userData = jsonEncode(provider.user!.toJson()); // Use toJson
    await updateUserData(context, 'userData', userData);
  } catch (e) {
    print(e);
    MessageService.showSnackBar('Error fetching user data $e');
  }
  final String? userData = await storage.read(key: 'userData');
  return userData != null ? jsonDecode(userData) : null;
}

Future<Map<String, dynamic>?> readData(BuildContext context, String key) async {
  final String? data = await storage.read(key: key);
  print(data);
  return jsonDecode(data!);
}

Future<String?> readLn(BuildContext context, String key) async {
  final String? data = await storage.read(key: key);
  print(data);
  return data;
}
