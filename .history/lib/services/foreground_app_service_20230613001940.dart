import 'package:flutter/services.dart';

class ForegroundAppService {
  static const MethodChannel _channel = MethodChannel('app_info_channel');

  static Future<String> getForegroundApp() async {
    try {
      final String foregroundApp = await _channel.invokeMethod('getForegroundApp');
      return foregroundApp;
    } catch (e) {
      print('Error getting foreground app: $e');
      return '';
    }
  }
}
