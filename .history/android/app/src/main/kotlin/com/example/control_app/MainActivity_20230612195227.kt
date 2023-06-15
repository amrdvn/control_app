import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.restriction_service"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startService()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, _ ->
            if (call.method == "startService") {
                startService()
            } else if (call.method == "checkRestriction") {
                checkRestriction()
            }
        }
    }

    private fun startService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(Intent(this, MyAccessibilityService::class.java))
        } else {
            startService(Intent(this, RestrictionService::class.java))
        }
    }

    private fun checkRestriction() {
        val intent = Intent(this, RestrictionService::class.java)
        intent.action = "CHECK_RESTRICTION"
        startService(intent)
    }
}
