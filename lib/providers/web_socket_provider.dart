// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class WebSocketService with ChangeNotifier {
//   late IO.Socket socket;

//   WebSocketService() {
//     socket = IO.io('http://localhost:5000', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.on('tweetAdded', (data) {
//       // Handle real-time tweet addition
//       notifyListeners();
//     });
//   }
// }
