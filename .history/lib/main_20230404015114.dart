import 'package:control_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth=
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