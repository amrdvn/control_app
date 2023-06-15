
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
      String packageName = app.packageName;
      String appName = app.appName;

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
