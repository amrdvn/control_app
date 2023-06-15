package com.example.control_app
import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.Process

class KillAppService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val packageName = intent?.getStringExtra("package_name")
        packageName?.let {
            try {
                // Kill the app
Process.killProcess(this.packageManager.getPackageInfo(it, 0).applicationInfo.uid)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}
