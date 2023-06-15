package com.example.control_app

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "your_channel_name" // Kanal adınızı buraya girin

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "disableApp") { // Dart tarafından disableApp çağrısı yapılırsa
                val packageName = call.argument<String>("packageName")
                disableApp(packageName, result)
            } else {
                result.notImplemented()
            }
        }
    }

private fun disableApp(packageName: String?, result: MethodChannel.Result) {
    packageName?.let {
        val componentName = ComponentName(packageName, "$packageName.MainActivity")
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }
    result.success(true)
}*/

}