import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BildirimServisi{
  final FirebaseMessaging _fcm=FirebaseMessaging();

  Future initialise() async{
    if (Platform.isIOS){
      _fcm.requestPermission(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
    );
  }




}