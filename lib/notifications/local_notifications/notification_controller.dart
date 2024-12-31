import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/main.dart';
import 'package:AgriGuide/models/post_model.dart';
import 'package:AgriGuide/screens/postScreen/post_detail_screen.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Ensure this import is present
import 'package:intl/intl.dart';

class NotificationController {
  // Use this method when a new notification or schedule is created
  @pragma('vm:entry-point')
  static Future onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    debugPrint("Notification created: ${receivedNotification.id}");
  }

  // Use this method every time a new notification is displayed
  @pragma('vm:entry-point')
  static Future onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    debugPrint("Notification displayed: ${receivedNotification.id}");
  }

  // Use this method to detect when a user taps on a notification
  @pragma('vm:entry-point')
  static Future onActionReceived(ReceivedAction receivedAction) async {
    debugPrint("Notification action received: ${receivedAction.id}");

    // Extract the post ID from the payload
    String? postId = receivedAction.payload?['postId'];
    print(postId);

    if (postId != null) {
      // Show loading spinner
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Fetch the Tweet object using the post ID
      Tweet? tweet = await fetchTweetById(postId);

      // Dismiss loading spinner
      navigatorKey.currentState?.pop();

      if (tweet != null) {
        // Navigate to PostDetailScreen with the fetched Tweet object
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(tweet: tweet),
          ),
        );
      } else {
        print('Tweet not found for postId: $postId');
      }
    } else {
      print('Payload is null');
    }
  }

  // Use this method when a notification is dismissed
  @pragma('vm:entry-point')
  static Future onDismissedActionReceived(
      ReceivedNotification receivedNotification) async {
    debugPrint("Notification dismissed: ${receivedNotification.id}");
    await DatabaseHelper().insertNotification({
      'title': receivedNotification.title,
      'body': receivedNotification.body,
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });
  }

  // Example static function to fetch Tweet by ID
  static Future<Tweet?> fetchTweetById(String postId) async {
    final url = '$baseUrl/post/getPost/$postId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Tweet.fromJson(data);
    } else {
      print('Failed to fetch Tweet: ${response.statusCode}');
      return null;
    }
  }
}
