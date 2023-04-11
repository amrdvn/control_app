import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<String> getToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
  String? token = doc.data()!['token'];
  return token!;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('onBackgroundMessage received: $message');
}

void configureFirebaseMessaging() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token = await getToken();
  messaging.subscribeToTopic('all');
  messaging.getToken().then((value) {
    print('token: $value');
  });
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidInit = AndroidInitializationSettings('app_icon');
  var initializationSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  messaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _showNotification(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      // Uygulama kapalıyken bildirime tıklanınca yapılacak işlemler
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      // Uygulama arka planda iken bildirime tıklanınca yapılacak işlemler
    },
  );
}

Future<void> _showNotification(Map<String, dynamic> message) async {
  var androidDetails = AndroidNotificationDetails(
      "channelId", "channelName", "channelDescription",
      importance: Importance.max, priority: Priority.high);
  var notificationDetails =
      NotificationDetails(android: androidDetails);
  await FlutterLocalNotificationsPlugin().show(
      0, message['notification']['title'], message['notification']['body'],
      notificationDetails);
}
