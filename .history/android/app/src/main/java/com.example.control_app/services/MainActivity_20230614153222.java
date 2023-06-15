package com.example.control_app;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.control_app/kill_app";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("killApp")) {
                                String packageName = call.argument("package_name");
                                killApp(packageName);
                                result.success(0);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    void killApp(String packageName) {
        Intent intent = new Intent(this, KillAppService.class);
        intent.putExtra("package_name", packageName);
        startService(intent);
    }
}
