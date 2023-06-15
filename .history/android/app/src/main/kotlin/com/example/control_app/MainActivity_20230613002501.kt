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

    private fun getForegroundAppPackageName(): String {
        // Burada, mevcut aktif uygulamanın paket adını alacak yöntemi yazmanız gerekmektedir.
        // Bu, Android platformuna özgü bir kod parçasıdır ve sizin uygulamanıza bağlıdır.
        // Mevcut aktif uygulamanın paket adını almak için gerekli işlemleri yapın.
        // Ardından, alınan paket adını bir dize olarak döndürün.

        // Örnek bir dönüş değeri:
        return "com.example.foregroundapp"
    }
}
