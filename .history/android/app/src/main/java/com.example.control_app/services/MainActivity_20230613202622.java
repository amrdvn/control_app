import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.yourdomain.yourapp/active_app";

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler((call, result) -> {
          if (call.method.equals("getActiveApp")) {
            String activeApp = MyAccessibilityService.getActiveApp();  // Assuming you have a method in MyAccessibilityService class to get the active app
            if (activeApp != null) {
              result.success(activeApp);
            } else {
              result.error("UNAVAILABLE", "Active app could not be fetched.", null);
            }
          } else {
            result.notImplemented();
          }
        });
  }
}
