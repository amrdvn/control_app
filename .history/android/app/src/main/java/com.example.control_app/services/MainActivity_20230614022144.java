package com.example.control_app
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.content.pm.PackageManager;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.control_app.services.MainActivity";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                        if (call.method.equals("disableApp")) {
                            String packageName = call.argument("packageName");
                            if (packageName != null) {
                                disableApp(packageName);
                                result.success("Uygulama başarıyla devre dışı bırakıldı.");
                            } else {
                                result.error("UNAVAILABLE", "Paket adı sağlanmadı.", null);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }
                }
            );
    }

    private void disableApp(String packageName) {
        PackageManager pm = this.getPackageManager();
        pm.setApplicationEnabledSetting(packageName, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, 0);
    }
}
