package com.example.control_app

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private lateinit var appIconManager: AppIconManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        appIconManager = AppIconManager(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app_icon_manager")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hideAppIcon" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName != null) {
                            appIconManager.hideAppIcon(packageName)
                            result.success(null)
                        } else {
                            result.error("INVALID_PACKAGE_NAME", "Invalid package name", null)
                        }
                    }
                    "showAppIcon" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName != null) {
                            appIconManager.showAppIcon(packageName)
                            result.success(null)
                        } else {
                            result.error("INVALID_PACKAGE_NAME", "Invalid package name", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }
}