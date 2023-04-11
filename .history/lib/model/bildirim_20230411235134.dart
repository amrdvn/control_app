import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init() {
    _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    var androidSettings = AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: androidSettings);

    _notificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        _showNotification(message.data['title'], message.data['body']);
      }
    });
  }

  void saveTokenToFirestore(String? token) {
    if (token == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .set({'token': token});
  }

  Future<void> _showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
        0, title, body, platformDetails,
        payload: 'New Payload');
  }
}
