import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BildirimServisi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void kayitEt(String uid) async {
    String token = await getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'token': token});
  }

  void bildirimleriBaslat() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Bildirim geldi!');
      print('Bildirim başlığı: ${message.notification!.title}');
      print('Bildirim içeriği: ${message.notification!.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Bildirime tıklandı!');
    });
  }
}
