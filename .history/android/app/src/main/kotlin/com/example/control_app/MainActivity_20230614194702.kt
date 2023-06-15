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
import androidx.appcompat.app.AppCompatActivity


class MainActivity : AppCompatActivity() {

    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var adminComponentName: ComponentName
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminComponentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

        methodChannel = MethodChannel(flutterEngine.dartExecutor, "com.example.control_app/channel")
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "lockApp") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    lockApp(packageName)
                    result.success("App locked")
                } else {
                    result.error("INVALID_ARGUMENT", "Package name not provided", null)
                }
            } else {
                result.notImplemented()
            }
        }

        val appToLockPackageName = "com.example.otherapp"
        lockApp(appToLockPackageName)
    }

    private fun lockApp(packageName: String) {
        devicePolicyManager.setApplicationHidden(adminComponentName, packageName, true)
    }
}
