import 'package:flutter/material.dart';
import 'package:usage/usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UygulamaKullanimi {
  static Future<void> uygulamaKullanimBilgisiGonder() async {
    // Firestore referansını al
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Kullanım verilerini almak için Usage paketini kullan
    Usage usage = Usage();
    await usage.init();

    // Kullanılan uygulamaların istatistiklerini al
    Map<String, UsageInfo> appStats = await usage.getUsageStats(
      DateTime.now().subtract(Duration(days: 7)), // Son 7 gün
      DateTime.now(), // Şu anki tarih
    );