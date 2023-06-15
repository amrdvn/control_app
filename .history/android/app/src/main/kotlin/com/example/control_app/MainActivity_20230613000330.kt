package com.example.control_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Erişilebilirlik hizmetini başlat
        startAccessibilityService()
    }

    private fun startAccessibilityService() {
        val intent = Intent(android.provider.Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)
    }
}
