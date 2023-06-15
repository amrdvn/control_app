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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

        val appToLockPackageName = "com.example.otherapp"
        lockApp(devicePolicyManager, adminComponentName, appToLockPackageName)
    }

    private fun lockApp(
        devicePolicyManager: DevicePolicyManager,
        adminComponentName: ComponentName,
        packageName: String
    ) {
        devicePolicyManager.setApplicationHidden(adminComponentName, packageName, true)
    }
}