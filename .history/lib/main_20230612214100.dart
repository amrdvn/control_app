import 'dart:convert';
import 'dart:io';

import 'package:control_app/pages/home.dart';
import 'package:control_app/pages/login.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChannels.lifecycle.setMessageHandler((msg) {
    if (msg == AppLifecycleState.resumed.toString()) {
      checkOpenedApp();
    }
    return null;
  });
  runApp(MyApp());
}
void checkOpenedApp() async {
  String openedApp = await DeviceApps.getLauncherPackageName();
  
  // "uygulama_kisit.json" dosyasının konumunu alın
  Directory? appDirectory = await getApplicationDocumentsDirectory();
  String filePath = '${appDirectory.path}/uygulama_kisit.json';

  // Dosyanın var olup olmadığını kontrol edin
  if (await File(filePath).exists()) {
    // Dosyayı okuyun
    String fileContent = await File(filePath).readAsString();
    Map<String, dynamic> kisitlar = json.decode(fileContent);

    // Açılan uygulamanın adını kontrol edin
    if (kisitlar.containsKey(openedApp)) {
      String uygulamaAdi = kisitlar[openedApp]['uygulama_adi'];
      print('Açılan uygulama: $uygulamaAdi');
      // Burada yapmak istediğiniz işlemleri gerçekleştirin
    } else {
      print('Açılan uygulama kısıtlı değil');
    }
  } else {
    print('Hata: "uygulama_kisit.json" dosyası bulunamadı');
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null)
      {
        return MaterialApp(
      title: 'Email ve Şifre girin',
      theme: ThemeData(
        primarySwatch: Colors.red,
        
      ),
      debugShowCheckedModeBanner: false,
      
      home: HomeScreen(),
      
      

    );
      }
      else
      {
        return MaterialApp(
      title: 'Email ve Şifre girin',
      theme: ThemeData(
        primarySwatch: Colors.red,
        
      ),
      debugShowCheckedModeBanner: false,
      
      home: LoginScreen(),
      
      

    );
      }
    
    
  }
}