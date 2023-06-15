import 'package:control_app/pages/home.dart';
import 'package:control_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const platform = MethodChannel('com.example.restriction_service');
  platform.invokeMethod('startService');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return MaterialApp(
      title: 'Email ve Şifre girin',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: user != null ? HomeScreen() : LoginScreen(),
    );
  }
}
