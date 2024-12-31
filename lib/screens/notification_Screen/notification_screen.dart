import 'dart:convert';

import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/notifications/local_notifications/local_notifications.dart';
import 'package:AgriGuide/notifications/local_notifications/notification_controller.dart';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/utils/helper_functions.dart';
import 'package:AgriGuide/widgets/divider_line.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationScreen extends StatefulWidget {
  final String? payload;
  final bool? newNotification;

  const NotificationScreen({super.key, this.payload, this.newNotification});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool turnOffNotifications = false;
  bool soundEnabled = true;
  bool highPriority = true;
  bool vibrate = true;
  bool reminders = true;
  bool doNotDisturb = false;

  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _viewAllNotifications;
    AwesomeNotifications().setListeners(
      onDismissActionReceivedMethod:
          NotificationController.onDismissedActionReceived,
      onActionReceivedMethod: NotificationController.onActionReceived,
    );
  }

  Future<void> _loadNotifications() async {
    List<Map<String, dynamic>> notifications =
        await DatabaseHelper().getNotifications();

    // Create a mutable copy of the notifications list
    List<Map<String, dynamic>> mutableNotifications =
        List<Map<String, dynamic>>.from(notifications);

    // Sort notifications by timestamp in descending order
    mutableNotifications
        .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    setState(() {
      _notifications = mutableNotifications;
    });
  }

  Future<void> _viewAllNotifications() async {
    List<int> notificationIds = _notifications
        .map((notification) => notification['id'] as int)
        .toList();

    await DatabaseHelper().markMultipleAsSeen(notificationIds);

    // Create a mutable copy of the notifications list for state update
    // List<Map<String, dynamic>> updatedNotifications =
    //     _notifications.map((notification) {
    //   Map<String, dynamic> mutableNotification =
    //       Map<String, dynamic>.from(notification);
    //   mutableNotification['isSeen'] = true; // Mark as seen in the local state
    //   return mutableNotification;
    // }).toList();

    // setState(() {
    //   _notifications = updatedNotifications;
    // });
  }

  Future<void> _deleteAllNotifications() async {
    await DatabaseHelper().deleteAllNotifications();
    _loadNotifications(); // Refresh the notifications list after deletion
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text('Turn off Notifications'),
                      value: turnOffNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          turnOffNotifications = value;
                          print('cancle: $value');
                          if (value) {
                            LocalNotifications.cancelAll();
                          }
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                    SwitchListTile(
                      title: const Text('Reminders'),
                      subtitle: const Text(
                        'Get occasional reminders about tips & tricks and your scheduled plan',
                      ),
                      value: reminders,
                      onChanged: (bool value) {
                        setState(() {
                          reminders = value;
                          if (!value) {
                            LocalNotifications.cancelAll();
                          } else {
                            LocalNotifications.showScheduledNotifications(
                              title: 'Reminder',
                              body: 'This is a reminder',
                              payload: 'Reminder payload',
                            );
                          }
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                    SwitchListTile(
                      title: const Text('Use high priority Notifications'),
                      value: highPriority,
                      onChanged: (bool value) {
                        setState(() {
                          highPriority = value;
                          LocalNotifications.updateNotificationPriority(value);
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                    SwitchListTile(
                      title: const Text('Vibrate'),
                      value: vibrate,
                      onChanged: (bool value) {
                        setState(() {
                          vibrate = value;
                          LocalNotifications.updateNotificationVibration(value);
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                    SwitchListTile(
                      title: const Text('Notification Sound'),
                      value: soundEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          soundEnabled = value;
                          LocalNotifications.updateNotificationSound(value);
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                    SwitchListTile(
                      title: const Text('Do Not Disturb'),
                      subtitle: const Text(
                        'Mute notifications during specific times',
                      ),
                      value: doNotDisturb,
                      onChanged: (bool value) {
                        setState(() {
                          doNotDisturb = value;
                          LocalNotifications.updateDoNotDisturb(value);
                        });
                      },
                    ),
                    DividerLine().horizontalDividerLine(context),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationGroup(
    BuildContext context,
    String groupName,
    List<Map<String, dynamic>> notifications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  await DatabaseHelper().deleteAllNotifications();
                  await _loadNotifications();
                },
                icon: const Icon(Icons.clear_all_rounded),
                tooltip: LocaleData.clearAll.getString(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                groupName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        ...notifications.map(
          (notification) => Dismissible(
            key: ValueKey(notification['id']),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                await DatabaseHelper().deleteNotification(notification['id']);
                await _loadNotifications(); // Refresh the notifications list after a single notification is deleted
              }
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: notification['isSeen'] == 0
                    ? const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.red,
                      )
                    : null,
                title: Text(notification['title'] ?? 'No Title'),
                subtitle: Text(notification['body'] ?? 'No Body'),
                trailing: const Icon(Icons.clear, color: Colors.grey),
              ),
            ),
          ),
        )
      ],
    );
  }

  Map payload = {};

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is ReceivedAction) {
      payload = jsonDecode(data.payload!['payload']!);
    }
    setState(() {
      _viewAllNotifications();
    });
    Map<String, List<Map<String, dynamic>>> groupedNotifications = {
      'Today': [],
      'Yesterday': [],
      'Older': [],
    };

    for (var notification in _notifications) {
      final timestamp = DateTime.parse(notification['timestamp']);
      final formattedTime = formatTimestamp2(context, timestamp);

      if (formattedTime == LocaleData.today.getString(context)) {
        groupedNotifications['Today']!.add(notification);
      } else if (formattedTime == LocaleData.yesterday.getString(context)) {
        groupedNotifications['Yesterday']!.add(notification);
      } else {
        groupedNotifications['Older']!.add(notification);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.notifications.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showNotificationSettings(context);
            },
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          LocalNotifications.showSimpleNotifications(
            title: 'This is simple notification',
            body: 'This is simple body',
            payload: 'my payload',
            color: Colors.green,
            imageUrl:
                'https://th.bing.com/th?id=OIP.47QUPskvTmW6_BkXWSh5MQHaFo&w=286&h=217&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
          );
        },
        color: Colors.green,
        icon: const Icon(Icons.notification_add),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                LocaleData.noNotifications.getString(context),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView(
              children: [
                if (groupedNotifications['Today']!.isNotEmpty)
                  _buildNotificationGroup(
                      context,
                      LocaleData.today.getString(context),
                      groupedNotifications['Today']!),
                const Divider(),
                if (groupedNotifications['Yesterday']!.isNotEmpty)
                  _buildNotificationGroup(
                      context,
                      LocaleData.yesterday.getString(context),
                      groupedNotifications['Yesterday']!),
                if (groupedNotifications['Older']!.isNotEmpty)
                  _buildNotificationGroup(
                      context,
                      LocaleData.older.getString(context),
                      groupedNotifications['Older']!),
                Text(payload.toString()),
              ],
            ),
    );
  }
}
