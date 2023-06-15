package com.example.control_app
package com.example.yourapp

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class AppIconManagerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var appIconManager: AppIconManager

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "app_icon_manager")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        appIconManager = AppIconManager(context)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "app_icon_manager")
            val appIconManagerPlugin = AppIconManagerPlugin()
            appIconManagerPlugin.context = registrar.context()
            appIconManagerPlugin.appIconManager = AppIconManager(appIconManagerPlugin.context)
            channel.setMethodCallHandler(appIconManagerPlugin)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
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

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
