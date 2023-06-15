import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.control_app/aktifUygulamaAdi"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAktifUygulamaAdi") {
                val activeAppName = getActiveAppName() // Aktif uygulama adını alacak yöntemi burada çağırın
                result.success(activeAppName)
            } else {
                result.notImplemented()
            }
        }
    }

    
}
