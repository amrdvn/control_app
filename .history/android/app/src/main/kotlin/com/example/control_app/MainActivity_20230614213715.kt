package com.example.control_app
import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.control_app.lock_device"

    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var componentName: ComponentName

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        componentName = ComponentName(this, AdminReceiver::class.java)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "lockDevice" -> {
                    val duration = call.argument<Int>("duration") ?: 0
                    lockDevice(duration)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun lockDevice(duration: Int) {
        if (devicePolicyManager.isAdminActive(componentName)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                devicePolicyManager.lockNow()
            } else {
                devicePolicyManager.lockNow()
                Thread.sleep(duration * 1000L)
                devicePolicyManager.resetPassword("", 0)
            }
        }
    }

    class AdminReceiver : DeviceAdminReceiver()
}
