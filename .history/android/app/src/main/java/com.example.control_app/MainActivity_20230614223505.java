package com.example.control_app;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "myapp/screenLock";
    private static final int REQUEST_CODE_ENABLE_ADMIN = 1;
    private DevicePolicyManager devicePolicyManager;
    private ComponentName componentName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        devicePolicyManager = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
        componentName = new ComponentName(this, AdminReceiver.class);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("lockScreen")) {
                        int duration = call.argument("duration");
                        lockScreen(duration);
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void lockScreen(int duration) {
        if (devicePolicyManager.isAdminActive(componentName)) {
            devicePolicyManager.lockNow();
            showToast("Screen locked for " + duration + " seconds.");
            new android.os.Handler().postDelayed(
                    () -> {
                        devicePolicyManager.setPasswordQuality(componentName, DevicePolicyManager.PASSWORD_QUALITY_UNSPECIFIED);
                        devicePolicyManager.lockNow();
                        showToast("Screen unlocked.");
                    },
                    duration * 1000);
        } else {
            Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
            intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName);
            intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Enable admin permission to lock the screen.");
            startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN);
        }
    }

    private void showToast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }
}
