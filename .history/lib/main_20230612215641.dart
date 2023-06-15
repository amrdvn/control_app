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
import 'package:device_apps/device_apps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
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