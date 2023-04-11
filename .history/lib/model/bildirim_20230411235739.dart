import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  String? get userId => null;

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    saveTokenToFirestore(token);
    return token;
  }

  void saveTokenToFirestore(String? token) {
    if (token == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'token': token});
  }

  Future<void> initialize() async {
    if (Platform.isIOS) {
      // Request permission for iOS devices
      _fcm.requestPermission();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle your message here
      print('onMessage: $message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle your message here
      print('onMessageOpenedApp: $message');
    });
  }
}
