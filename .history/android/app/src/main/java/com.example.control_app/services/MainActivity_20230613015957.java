import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static final String ACTION_ACCESSIBILITY_EVENT = "com.example.control_app.ACCESSIBILITY_EVENT";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        registerReceiver(accessibilityEventReceiver, new IntentFilter(ACTION_ACCESSIBILITY_EVENT));
    }

    private final BroadcastReceiver accessibilityEventReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(ACTION_ACCESSIBILITY_EVENT)) {
                String packageName = intent.getStringExtra("packageName");
                new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "app_info_channel")
                        .invokeMethod("onForegroundAppChanged", packageName);
            }
        }
    };
}
