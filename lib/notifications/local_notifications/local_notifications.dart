import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static const String channelId = 'basic_channel';
  static const String periodicChannelId = 'periodic_channel';
  static const String scheduledChannelId = 'scheduled_channel';

  static Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future init() async {
    await requestNotificationPermission();
    _setChannel;
  }

  static Future<void> _initializeNotificationChannels({
    bool playSound = true,
    bool enableVibration = true,
    NotificationImportance importance = NotificationImportance.High,
  }) async {
    await _setChannel(
        channelId,
        'Basic notifications',
        'Notification channel for basic tests',
        playSound,
        enableVibration,
        importance);
    await _setChannel(
        periodicChannelId,
        'Periodic notifications',
        'Notification channel for periodic tests',
        playSound,
        enableVibration,
        importance);
    await _setChannel(
        scheduledChannelId,
        'Scheduled notifications',
        'Notification channel for scheduled tests',
        playSound,
        enableVibration,
        importance);
  }

  static Future<void> _setChannel(
    String channelKey,
    String channelName,
    String channelDescription,
    bool playSound,
    bool enableVibration,
    NotificationImportance importance,
  ) async {
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: channelKey,
        channelName: channelName,
        channelDescription: channelDescription,
        defaultColor: Colors.green,
        ledColor: Colors.green,
        importance: importance,
        playSound: playSound,
        enableVibration: enableVibration,
      ),
    );
  }

  static Future showSimpleNotifications({
    required String title,
    required String body,
    required String payload,
    String? imageUrl, // Optional parameter for the image URL
    Color? color, // Optional parameter for the tile color
  }) async {
    // Parse the payload string into a Map
    final Map<String, dynamic> payloadMap = jsonDecode(payload);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {'postId': payloadMap['postId']}, // Ensure postId is included
        bigPicture: imageUrl, // Add image if provided
        notificationLayout: imageUrl != null
            ? NotificationLayout.Messaging
            : NotificationLayout.Default,
        color: color ?? Colors.green, // Set tile color, default to green
      ),
    );
  }

  static Future showPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 20,
        channelKey: periodicChannelId,
        title: title,
        body: body,
        payload: {'payload': payload},
        bigPicture: '',
      ),
      schedule: NotificationInterval(
        interval: const Duration(seconds: 60), // Interval in seconds
        repeats: true,
      ),
    );
  }

  static Future<void> showScheduledNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 30,
        channelKey: scheduledChannelId,
        title: title,
        body: body,
        payload: {'payload': payload},
      ),
      schedule: NotificationCalendar(
        timeZone: tz.local.name,
        second: tz.TZDateTime.now(tz.local).second + 5,
        repeats: false,
        allowWhileIdle: true,
      ),
    );
  }

  static Future cancel(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future cancelAll() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future updateNotificationSound(bool value) async {
    await _initializeNotificationChannels(playSound: value);
  }

  static Future updateNotificationPriority(bool value) async {
    await _initializeNotificationChannels(
        importance: value
            ? NotificationImportance.Max
            : NotificationImportance.Default);
  }

  static Future updateNotificationVibration(bool value) async {
    await _initializeNotificationChannels(enableVibration: value);
  }

  static Future updateDoNotDisturb(bool value) async {
    if (value) {
      await cancelAll();
    } else {
      await _initializeNotificationChannels();
    }
  }
}
