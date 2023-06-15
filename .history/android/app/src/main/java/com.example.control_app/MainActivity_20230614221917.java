import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.content.Context;
import android.app.Activity;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Intent;
import android.content.IntentFilter;
import android.widget.Toast;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/powerOff";
    static final int RESULT_ENABLE = 1;
    DevicePolicyManager deviceManger;
    ComponentName compName;

@Override
public void configureFlutterEngine(FlutterEngine flutterEngine) {
    compName = new ComponentName(this, DeviceAdmin.class);
    deviceManger = (DevicePolicyManager)
            getSystemService(Context.DEVICE_POLICY_SERVICE);
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                    if (call.method.equals("powerOff")) {
                        Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
                        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, compName);
                        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "You should enable the app!");
                        startActivityForResult(intent, RESULT_ENABLE);
                    }
                }
            });
}

@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    switch (requestCode) {
        case RESULT_ENABLE:
            if (resultCode == Activity.RESULT_OK) {
                deviceManger.lockNow();
            }
            return;
    }
}
}