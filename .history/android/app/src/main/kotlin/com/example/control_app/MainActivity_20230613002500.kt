import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_info_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Kanalı oluştur ve platform metodunu çağır
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getForegroundApp") {
                // Aktif uygulamanın paket adını al
                val packageName = getForegroundAppPackageName()

                // Sonucu geri dön
                result.success(packageName)
            } else {
                result.notImplemented()
            }
        }
    }

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
}
