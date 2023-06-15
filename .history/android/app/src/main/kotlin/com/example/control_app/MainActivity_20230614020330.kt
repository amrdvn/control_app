import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.control_app/MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "disableApp") {
                val packageName: String? = call.argument("packageName")

                if (packageName != null) {
                    disableApp(packageName)
                    result.success("Uygulama başarıyla devre dışı bırakıldı.")
                } else {
                    result.error("UNAVAILABLE", "Paket adı sağlanmadı.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun disableApp(packageName: String) {
        val pm: PackageManager = this.packageManager
        pm.setApplicationEnabledSetting(packageName, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, 0)
    }
}
