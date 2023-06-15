import 'package:flutter/services.dart';

class LockDeviceService {
  static const platform = MethodChannel('com.example.control_app.lock');

  static Future<void> lockDevice(Duration duration) async {
    try {
      int seconds = duration.inSeconds;
      await platform.invokeMethod('lockDevice', {'duration': seconds});
    } on PlatformException catch (e) {
      print("Kilitlenirken hata oluştu: ${e.message}");
    }
  }
}
