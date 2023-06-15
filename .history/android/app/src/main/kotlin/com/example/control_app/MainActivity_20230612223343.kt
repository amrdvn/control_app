import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.app.ActivityManager
import android.content.pm.PackageManager

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

    private fun getActiveAppName(): String {
    val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    val foregroundTaskInfo = am.getRunningTasks(1)?.get(0)
    val packageName = foregroundTaskInfo?.topActivity?.packageName
    val packageManager = packageManager
    val applicationInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
    val appName = packageManager.getApplicationLabel(applicationInfo).toString()
    return appName
}

}
