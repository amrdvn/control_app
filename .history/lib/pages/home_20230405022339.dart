import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_app/model/user_model.dart';
import 'package:control_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}


class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
      





  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    aramaKaydiGonder();
    sonkonumBilgisiGonder();
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




//arama kaydı
void aramaKaydiGonder() async {
  await CallLog.query();
  Iterable<CallLogEntry> entries = await CallLog.get();
  
  List<CallLogModel> callLogList = [];

  for (var entry in entries) {
    CallLogModel callLog = CallLogModel(
      number: entry.number ?? '',
      duration: entry.duration ?? 0,
      timestamp: entry.timestamp ?? 0, 
      date: DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
    );
    callLogList.add(callLog);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference callLogs =
      firestore.collection('logs');

  for (CallLogModel callLog in callLogList) {
    await callLogs.add({
      'number': callLog.number,
      'duration': callLog.duration,
      'timestamp': callLog.timestamp,
      'date': callLog.date,
    });
  }
}
  

  Future<void> sonkonumBilgisiGonder() async {
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
    await _firestore.collection('konumlar').add(konum.toMap());
  }
}
Future<void> sendAppUsageDataToFirestore() async {
  // Firestore instance'ı oluştur
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // AppUsage kütüphanesini kullanarak uygulama kullanım istatistiklerini al
  UsageStats.grantUsagePermission();
    
  await appUsage(
    DateTime.now().subtract(Duration(days: 1)), // Verileri 1 gün öncesine kadar al
    DateTime.now(), // Şu anki zamanı kullan
  );

  // Firestore'a gönderilecek veri listesi
  List<AppUsageData> appUsageDataList = [];

  // AppUsage kütüphanesinden alınan verileri Firestore'a uygun şekilde dönüştür
  Map<String, double> appUsageMap = appUsage.getAppUsageMap();
  appUsageMap.forEach((appName, durationInMinutes) {
    AppUsageData appUsageData = AppUsageData(
      appName: appName,
      usageDurationInMinutes: durationInMinutes.round(),
    );
    appUsageDataList.add(appUsageData);
  });

  // Firestore'a verileri gönder
  await _firestore.collection('appUsageData').add({
    'timestamp': DateTime.now(),
    'usageData': appUsageDataList.map((appUsageData) => appUsageData.toMap()).toList(),
  });
}

  

  // logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}

