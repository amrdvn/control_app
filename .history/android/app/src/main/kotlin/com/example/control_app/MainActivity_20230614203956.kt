package com.example.control_app
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app_icon_manager").setMethodCallHandler { call, result ->
            if (call.method == "hideAppIcon") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    hideAppIcon(packageName)
                    result.success(null)
                } else {
                    result.error("INVALID_PACKAGE_NAME", "Invalid package name", null)
                }
            } else if (call.method == "showAppIcon") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    showAppIcon(packageName)
                    result.success(null)
                } else {
                    result.error("INVALID_PACKAGE_NAME", "Invalid package name", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun hideAppIcon(packageName: String) {
        val packageManager = packageManager
        val componentName = packageManager.getLaunchIntentForPackage(packageName)?.component
        if (componentName != null) {
            packageManager.setComponentEnabledSetting(
                componentName,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }
    }

    private fun showAppIcon(packageName: String) {
        val packageManager = packageManager
        val componentName = packageManager.getLaunchIntentForPackage(packageName)?.component
        if (componentName != null) {
            packageManager.setComponentEnabledSetting(
                componentName,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
        }
    }
}