import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  //request notification permission
  static Future init() async {
    _firebaseMessaging.requestPermission(
      announcement: true,
    );

    //get the device's fcm token
    final token = await _firebaseMessaging.getToken();
    print(token);
  }
}
