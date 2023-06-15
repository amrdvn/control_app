import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_apps/device_apps.dart';

class UygulamaListesi {
  final String uid;

  UygulamaListesi({required this.uid});

  Future<void> fetchAndSaveAppListToFirebase() async {
    await Firebase.initializeApp();

    List<Application> installedApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );

    List<Application> userInstalledApps = installedApps.where((app) {
      return !app.systemApp &&
          app.packageName != 'com.android.vending' &&
          app is! ApplicationSystem;
    }).toList();

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
