package com.example.control_app

package com.example.yourapp

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager

class AppIconManager(private val context: Context) {
    fun hideAppIcon(packageName: String) {
        val packageManager = context.packageManager
        val componentName = ComponentName(packageName, "$packageName.MainActivity")
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    fun showAppIcon(packageName: String) {
        val packageManager = context.packageManager
        val componentName = ComponentName(packageName, "$packageName.MainActivity")
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }
}
