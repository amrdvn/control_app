import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_app/model/user_model.dart';
import 'package:control_app/model/user_model.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
  Duration? _selectedDuration=Duration(minutes: 30);

  init() async{
      String? deviceToken=await getToken();
      print("############ DEVICE TOKEN ############ ");
      print(deviceToken);
      print("###################################### ");

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
        String? title=remoteMessage.notification!.title;
        String? description=remoteMessage.notification!.body;
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
      String packageName = app.appName;
      String appName = app.packageName;

      QuerySnapshot querySnapshot = await logsCollection
          .doc(uid)
          .collection('uygulama_kisit')
          .where('uygulama_adi', isEqualTo: appName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await logsCollection
            .doc(uid)
            .collection('uygulama_kisit')
            .doc(packageName)
            .set({'uygulama_adi': appName, 'kisit': 0});
      }
    }

    print('Uygulama listesi başarıyla Firestore\'a kaydedildi.');
  } catch (e) {
    print('Hata: $e');
  }
}
  

// Uygulama Kilitleme Kısmı //
// Uygulama Kilitleme Kısmı //
// Uygulama Kilitleme Kısmı //
Future<void> storeLocallyUygulamaKisitValues(String uid) async {
  // Get the uygulama_adi and kisit values from Firestore.
  var querySnapshot = await FirebaseFirestore.instance
      .collection('logs')
      .doc(uid)
      .collection('uygulama_kisit')
      .get();

  // Create a map of the uygulama_adi and kisit values.
  Map<String, int> uygulamaKisitValues = {};
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    uygulamaKisitValues[doc['uygulama_adi']] = doc['kisit'];
  }

  // Write the map of the uygulama_adi and kisit values to a local file.
  File file = File('uygulama_kisit.json');
  await file.writeAsString(json.encode(uygulamaKisitValues));
}
class BackgroundService extends BackgroundService {
  @override
  Future<void> onStart(bool startedFromBoot) async {
    // Get the `kisit` value from the locally stored file.
    File file = File('uygulama_kisit.json');
    Map<String, int> uygulamaKisitValues = json.decode(await file.readAsString());

    // Listen for application launch events.
    FirebaseMessaging.onAppLaunched.listen((RemoteMessage remoteMessage) {
      // Get the package name of the application that was launched.
      String packageName = remoteMessage.notification?.launchApp?.packageName;

      // Check the `kisit` value for the application.
      if (uygulamaKisitValues.containsKey(packageName)) {
        // If the `kisit` value is greater than 0, then the application is restricted.
        if (uygulamaKisitValues[packageName] > 0) {
          // Prevent the application from launching.
          FirebaseMessaging.preventAppLaunch();
        }
      }
    });
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
        if (count == 5) break; // Sadece ilk 5 uygulamayı gönder
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
  DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
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
