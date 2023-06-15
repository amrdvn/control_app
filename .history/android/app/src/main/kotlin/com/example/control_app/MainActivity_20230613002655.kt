package com.example.control_app

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Erişilebilirlik hizmetini başlat
        startAccessibilityService()
    }

    private fun startAccessibilityService() {
        val intent = Intent(android.provider.Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)
    }

    private fun getForegroundAppPackageName(): String {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val foregroundTaskInfo = am.getRunningTasks(1)[0]
        val foregroundAppPackageName = foregroundTaskInfo.topActivity?.packageName
        return foregroundAppPackageName ?: ""
    }
}
