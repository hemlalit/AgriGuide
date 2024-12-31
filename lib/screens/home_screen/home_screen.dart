import 'dart:convert';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/main.dart';
import 'package:AgriGuide/notifications/local_notifications/local_notifications.dart';
import 'package:AgriGuide/screens/crop_care/crop_care_screen.dart';
import 'package:AgriGuide/screens/feedScreen/feed_screen.dart';
import 'package:AgriGuide/screens/home_screen/home_screen_content.dart';
import 'package:AgriGuide/screens/home_screen/select_appbar.dart';
import 'package:AgriGuide/screens/marketplace/farmer/marketplace_screen.dart';
import 'package:AgriGuide/screens/weather_screen.dart';
import 'package:AgriGuide/widgets/bottom_navbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../widgets/hamburger_menu.dart';

// function for listening to background changes

Future<void> _firebaseBackgroundMessage(RemoteMessage message) {
  if (message.notification != null) {
    print("some notificaions has been recieved");
  }
  return Future.value();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final List<Widget> _screens = [
    const HomeScreenContent(),
    const CropCareScreen(),
    const MarketplaceScreen(),
    const WeatherScreen(),
    const FeedScreen(),
  ];
  int _selectedIndex = 0;
  int _notificationCount = 0;
  bool _newNotification = false;

  late FirebaseMessaging _firebaseMessaging;
  String? _token;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchNotificationCount();

    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    _firebaseMessaging.requestPermission();

    // Get the registration token
    _firebaseMessaging.getToken().then((token) async {
      setState(() {
        _token = token!;
      });
      print("FCM Registration Token: $_token");
      await storage.write(key: 'fcmToken', value: _token);
      
      // Send this token to your server
      if (_token != null) {
        sendTokenToServer(_token!);
      }
    });

    // on background notification tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Background notificaiotn tapped");
        navigatorKey.currentState!
            .pushNamed('notification', arguments: message);
      }
    });

    //listen to background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    //listen to forefround messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print('Got Foreground message $payloadData');
      LocalNotifications.showSimpleNotifications(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadData,
      );
    });
  }

  Future<void> sendTokenToServer(String token) async {
    final userData =
          await storage.read(key: 'userData'); // await the read operation
      final data = jsonDecode(userData!);
    // safely unwrap the result
    const url = '$baseUrl/sendNotification/registerToken';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'userId': data['_id'],
      }),
    );

    if (response.statusCode == 200) {
      print('Token sent successfully');
    } else if (response.statusCode == 400) {
      print('Token already registered');
    } else {
      print('Failed to send token: ${response.statusCode}');
    }
  }

  Future<void> _fetchNotificationCount() async {
    List<Map<String, dynamic>> notifications =
        await DatabaseHelper().getNotifications();

    // Filter notifications to count only those with isSeen == 0
    int unseenCount = notifications
        .where((notification) => notification['isSeen'] == 0)
        .length;

    setState(() {
      _notificationCount = unseenCount;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _resetNotificationCount() async {
    setState(() {
      _notificationCount = 0;
      _newNotification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _fetchNotificationCount();
    });
    return Scaffold(
      appBar: selectAppBar(
          context, _selectedIndex, _notificationCount, _newNotification),
      drawer: const HamburgerMenu(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
