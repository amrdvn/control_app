import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'uygulama_kullanimi';
  
  Future<void> initialize() async {
    // FirebaseMessaging'i başlatın.
    await Firebase.initializeApp();
    
    // Cihaz token'ını alma ve Firestore'a kaydetme.
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'token': token});
    }
    
    // Bildirim dinleyicilerini ekleme.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification!.title}');
      // Firestore'a bildirimi ekleme.
      _firestore.collection(_collectionName).add({
        'title': message.notification!.title,
        'body': message.notification!.body,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
    
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Received message in background: ${message.notification!.title}');
      // Firestore'a bildirimi ekleme.
      await _firestore.collection(_collectionName).add({
        'title': message.notification!.title,
        'body': message.notification!.body,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return Future<void>.value();
    });
  }
}
