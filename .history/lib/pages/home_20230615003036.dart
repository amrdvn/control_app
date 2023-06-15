import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_app/model/user_model.dart';
import 'package:control_app/model/user_model.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'login.dart';
import 'package:control_app/model/aramakaydi_model.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:control_app/model/konum.dart';
import 'package:intl/intl.dart'; // intl paketini import ettik
import 'package:usage_stats/usage_stats.dart';
import 'package:control_app/model/uygulama_kullanimi.dart';
import 'package:control_app/model/uygulama_listesi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:control_app/model/lock_device_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  User? user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  UserModel loggedInUser = UserModel();
  List<EventUsageInfo> events = [];
  CollectionReference _usageStatsCollection =
      FirebaseFirestore.instance.collection('uygulama_kullanimi');
  Duration? _selectedDuration = Duration(minutes: 30);

  init() async {
    String? deviceToken = await getToken();
    print("############ DEVICE TOKEN ############ ");
    print(deviceToken);
    print("###################################### ");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
      Alert(context: context, title: title, desc: description).show();
    });
  }

  @override
  void initState() {
    init();
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      // aramaKaydiGonder();
      // sonkonumBilgisiGonder();
      // uygulama_istatistik();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control App"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 150,
              //   child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              // ),
              Text(
                "Hoş Geldiniz.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.ad} ${loggedInUser.soyad}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Veri gönderme sıklığı seçin: ",
                      style: TextStyle(
                        color: Color.fromARGB(137, 231, 6, 6),
                        fontWeight: FontWeight.w500,
                      )),
                  DropdownButton<Duration>(
                    value: _selectedDuration,
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value!;
                        logsGonder();
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: Duration(minutes: 1),
                        child: Text("1 dakika"),
                      ),
                      DropdownMenuItem(
                        value: Duration(minutes: 10),
                        child: Text("10 dakika"),
                      ),
                      DropdownMenuItem(
                        value: Duration(minutes: 30),
                        child: Text("30 dakika"),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 1),
                        child: Text("1 saat"),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 2),
                        child: Text("2 saat"),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: Text("Çıkış Yap"),
                  onPressed: () {
                    logout(context);
                  }),
              
            ],
          ),
        ),
      ),
    );
  }

  void verileriGonder(
      String collectionName, String uid, Map<String, dynamic> data) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection =
        firestore.collection('logs/$uid/$collectionName');
    await collection.add(data);
  }

  Future<void> eskiVerileriSil(String collectionPath, String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firestore.collection('logs/$uid/$collectionPath').get();
    List<Future<void>> futures = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      futures.add(doc.reference.delete());
    }
    await Future.wait(futures);
  }

//arama kaydı
  Future<void> aramaKaydiGonder() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;

    if (uid != null) {
      await CallLog.query();
      Iterable<CallLogEntry> entries = await CallLog.get();
      await eskiVerileriSil('aramaKaydi', uid);

      for (var entry in entries) {
        Map<String, dynamic> callLog = {
          'numara': entry.number ?? '',
          'saniye': entry.duration ?? 0,
          'timestamp': entry.timestamp ?? 0,
          'tarih': DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
        };

        verileriGonder('aramaKaydi', uid, callLog);
      }
    }
  }

  Future<void> sonkonumBilgisiGonder() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;
    if (uid != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Kullanıcının oturum açtığından emin olun
      if (_auth.currentUser != null) {
        // Konum bilgisini al
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Konum bilgisi objesini oluştur
        Konum konum = Konum(
          latitude: position.latitude,
          longitude: position.longitude,
          tarih: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        );

        // Firestore'a konum bilgisini gönder

        verileriGonder('konumlar', uid, konum.toMap());
      }
    }
  }

//canlı konum bilgisini gönder
  // void canliKonumGonder(String uid) {
  //   Geolocator.getPositionStream().listen((Position position) async {
  //     final collection = FirebaseFirestore.instance.collection('logs');
  //     await eskiVerileriSil('canli_konum', uid);
  //     await collection.doc(uid).set({
  //       'canli_konum': {
  //         'latitude': position.latitude,
  //         'longitude': position.longitude,
  //       },
  //     });
  //   });
  // }
  void canliKonumGonder(String uid) {
  final collection = FirebaseFirestore.instance.collection('logs');

  // Belgeyi al ve takip değerini kontrol et
  collection.doc(uid).get().then((snapshot) async {
    if (!snapshot.exists) {
      // Belge yoksa oluştur ve takip değerini 0 olarak ayarla
      await collection.doc(uid).set({
        'canli_konum': {
          'latitude': 0,
          'longitude': 0,
          'takip': 0,
        },
      });
    } else {
      // Belge varsa takip değerini kontrol et
      final data = snapshot.data();
      if (data != null && data['canli_konum'] != null && data['canli_konum']['takip'] == 1) {
        // Takip değeri 1 ise konum takibini başlat
        _konumTakibiBaslat(uid, collection);
      }
    }
  });
}

void _konumTakibiBaslat(String uid, CollectionReference collection) {
  Geolocator.getPositionStream().listen((Position position) async {
    await collection.doc(uid).set({
      'canli_konum': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'takip': 1,
      },
    }, SetOptions(merge: true));
  });
}



  //uygulama listesini getirir. model/uygulama_listesi.dart dosyasını kullanır.
  void uygulama_list() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference logsCollection =
        FirebaseFirestore.instance.collection('logs');
    String? uid = auth.currentUser?.uid;

    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: false,
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
      );

      for (Application app in apps) {
        String packageName = app.packageName;
        //String appName = app.appName;

        QuerySnapshot querySnapshot = await logsCollection
            .doc(uid)
            .collection('uygulama_kisit')
            .where('uygulama_adi', isEqualTo: packageName)
            .get();

        if (querySnapshot.docs.isEmpty) {
          await logsCollection
              .doc(uid)
              .collection('uygulama_kisit')
              .doc(packageName)
              .set({'uygulama_adi': packageName, 'kisit': 0});
        }
      }

      print('Uygulama listesi başarıyla Firestore\'a kaydedildi.');
    } catch (e) {
      print('Hata: $e');
    }
  }

// Uygulama Kaldırma Kısmı //
// Uygulama Kaldırma Kısmı //
// Uygulama Kaldırma Kısmı //
  void logsKaydet() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;

    if (uid != null) {
      CollectionReference logsCollection =
          FirebaseFirestore.instance.collection('logs');

      List<Map<String, dynamic>> data = [];

      QuerySnapshot snapshot =
          await logsCollection.doc(uid).collection('uygulama_kisit').get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        data.add({
          'uygulama_adi': doc.id,
          'kisit': doc.get('kisit'),
        });
      }

      String jsonData = jsonEncode(data);
      Directory? appDirectory = await getExternalStorageDirectory();
      String appPath = appDirectory!.path;
      String filePath = '$appPath/uygulama_kisit.json';

      File file = File(filePath);

      await file.writeAsString(jsonData);
      print('uygulama_kisit.json dosyası indirme klasörüne kaydedildi.');
    }
  }

  void uygulamaVeriSil(String uid, String packageName) async {
    String documentPath = 'logs/$uid/uygulama_kisit/$packageName';

    try {
      await FirebaseFirestore.instance.doc(documentPath).delete();
      print('Firestore verisi başarıyla silindi.');
    } catch (e) {
      print('Firestore verisi silinirken bir hata oluştu: $e');
    }
  }

  void uygulama_kaldir() async {
    Directory? appDirectory = await getExternalStorageDirectory();
    String appPath = appDirectory!.path;
    String filePath = '$appPath/uygulama_kisit.json';

    File file = File(filePath);
    String jsonData = await file.readAsString();
    List<dynamic> data = jsonDecode(jsonData);

    for (var app in data) {
      if (app['kisit'] == 1) {
        String appName = app['uygulama_adi'];
        print('$appName adlı uygulama kaldırıldı.');
        DeviceApps.uninstallApp(appName);
        uygulamaVeriSil(uid, appName);
      }
    }
  }

//uygulama kullanım istatistiği
  Future<void> uygulama_istatistik() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;
    if (uid != null) {
      UsageStats.grantUsagePermission();
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime.now().subtract(Duration(days: 10));

      List<EventUsageInfo> queryEvents =
          await UsageStats.queryEvents(startDate, endDate);

      setState(() {
        events = queryEvents.reversed.toList();
      });

      List<Map<String, dynamic>> top5Apps = [];
      int count = 0;
      for (var event in events) {
        if (count == 10) break; // Sadece ilk 10 uygulamayı gönder
        top5Apps.add({
          'uygulamaAdi': event.packageName!,
          'sonKullanim':
              DateTime.fromMillisecondsSinceEpoch(int.parse(event.timeStamp!))
                  .toIso8601String(),
        });
        count++;
      }
      await eskiVerileriSil('uygulama_istatistik', uid);

      for (var appData in top5Apps) {
        verileriGonder('uygulama_istatistik', uid, appData);
      }
    }
  }

  Future<String?> getToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return doc.data()?['token'] as String?;
  }

  // logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void zamanAyarla(Duration period) {
    Timer.periodic(period, (timer) {
      aramaKaydiGonder();
      sonkonumBilgisiGonder();
      uygulama_istatistik();
      uygulama_list();
      logsKaydet();
      canliKonumGonder(uid);
      uygulama_kaldir();
    });
  }

  void birDk() {
    final birdk = const Duration(minutes: 1);
    zamanAyarla(birdk);
  }

  void onDk() {
    final ondk = const Duration(minutes: 10);
    zamanAyarla(ondk);
  }

  void otuzDk() {
    final otuzdk = const Duration(minutes: 30);
    zamanAyarla(otuzdk);
  }

  void birSaat() {
    final birsaat = const Duration(hours: 1);
    zamanAyarla(birsaat);
  }

  void ikiSaat() {
    final ikisaat = const Duration(hours: 2);
    zamanAyarla(ikisaat);
  }

  void logsGonder() {
    switch (_selectedDuration?.inMinutes) {
      case 1:
        birDk();
        break;
      case 10:
        onDk();
        break;
      case 30:
        otuzDk();
        break;
      case 60:
        birSaat();
        break;
      case 120:
        ikiSaat();
        break;
      default:
        otuzDk();
        break;
    }
  }
}
