class AndroidUsage {
  static const MethodChannel _channel = const MethodChannel('android_usage');

  // Kullanım süresini al
  static Future<Map<String, dynamic>> getUsage() async {
    final Map<String, dynamic>? result =
        await _channel.invokeMethod('getUsage');
    return result ?? {};
  }
}