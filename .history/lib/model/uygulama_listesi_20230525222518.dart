import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class UygulamaListesi {
  final String uid;

  UygulamaListesi({required this.uid});

  Future<void> fetchAndSaveAppListToFirebase() async {
    await Firebase.initializeApp();

    List<Application> installedApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
    );

    List<Application> userInstalledApps = [];

    for (var app in installedApps) {
      if (app.systemApp || app.packageName == 'com.android.vending') continue;

      String appStoreUrl = 'https://play.google.com/store/apps/details?id=${app.packageName}';
      bool isInstalledFromPlayStore = await canLaunch(appStoreUrl);

      if (isInstalledFromPlayStore) {
        userInstalledApps.add(app);
      }
    }

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.reference().child('logs').child(uid);

    List<Map<String, dynamic>> appList = userInstalledApps.map((app) {
      return {
        'uygulama_listesi': app.appName,
        'kisit': 0,
      };
    }).toList();

    await databaseRef.set(appList);
  }
}
