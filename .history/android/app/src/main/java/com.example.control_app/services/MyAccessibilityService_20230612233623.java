import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Intent;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.view.accessibility.AccessibilityEvent;
import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class MyAccessibilityService extends AccessibilityService {

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        
        // Erişilebilirlik hizmeti yapılandırması
        AccessibilityServiceInfo serviceInfo = new AccessibilityServiceInfo();
        serviceInfo.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
        serviceInfo.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        serviceInfo.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
        setServiceInfo(serviceInfo);
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            // Erişilebilirlik etkinliği alındığında çalışır

            String packageName = event.getPackageName() != null ? event.getPackageName().toString() : "";
            Log.d("AccessibilityService", "Foreground App Package Name: " + packageName);

            // Flutter tarafına elde edilen uygulama adını iletiyoruz
            MethodChannel channel = new MethodChannel(getFlutterView(), "app_info_channel");
            channel.invokeMethod("onForegroundAppChanged", packageName);
        }
    }

    @Override
    public void onInterrupt() {
        // Hizmet kesintiye uğradığında çalışır
    }
}
