import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Intent;
import android.os.Bundle;
import android.view.accessibility.AccessibilityEvent;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class MyAccessibilityService extends AccessibilityService {

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        AccessibilityServiceInfo serviceInfo = new AccessibilityServiceInfo();
        serviceInfo.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
        serviceInfo.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        serviceInfo.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
        setServiceInfo(serviceInfo);
    }

    @Override
public void onAccessibilityEvent(AccessibilityEvent event) {
    if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
        String packageName = event.getPackageName() != null ? event.getPackageName().toString() : "";
        Log.d("AccessibilityService", "Foreground App Package Name: " + packageName);

        // MainActivity'ye mesajı iletmek için bir Intent oluşturun
        Intent intent = new Intent(MainActivity.ACTION_ACCESSIBILITY_EVENT);
        intent.putExtra("packageName", packageName);

        // Intent'i gönderin
        sendBroadcast(intent);
    }
}

    @Override
    public void onInterrupt() {
    }
}
