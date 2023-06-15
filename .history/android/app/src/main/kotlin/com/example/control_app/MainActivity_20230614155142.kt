package com.example.control_app

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.control_app/kill_app"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "killApp") {
                val packageName = call.argument<String>("package_name")
                killApp(packageName)
                result.success(0)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun killApp(packageName: String?) {
        val intent = Intent(this, KillAppService::class.java)
        intent.putExtra("package_name", packageName)
        startService(intent)
    }
}