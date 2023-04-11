import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bildirim {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    // Request for notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
    
    // Get user token
    String? token = await _firebaseMessaging.getToken();
    print('User FCM token: $token');
    
    // Save user token to Firestore
    if (token != null) {
      await _firestore.collection('users').doc(user!.uid).set({
        'token': token
      }, SetOptions(merge: true));
    }
    
    // Configure notification handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification!.title} - ${message.notification!.body}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened message: ${message.notification!.title} - ${message.notification!.body}');
    });
  }
}
