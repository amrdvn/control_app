package com.ex.services;

import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class MyAccessibilityService extends AccessibilityService {

    private List<String> kisitliUygulamalar = new ArrayList<>();

    @Override
    public void onCreate() {
        super.onCreate();
        parseKisitliUygulamalar();
    }

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        AccessibilityServiceInfo info = getServiceInfo();
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        setServiceInfo(info);
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            String packageName = event.getPackageName().toString();
            if (kisitliUygulamalar.contains(packageName)) {
                // Uygulama kısıtlı, açılmasını engelleyin ve uyarı verin
                Toast.makeText(this, "Bu uygulama kısıtlıdır.", Toast.LENGTH_SHORT).show();
                performGlobalAction(GLOBAL_ACTION_BACK);
            }
        }
    }

    @Override
    public void onInterrupt() {
    }

    private void parseKisitliUygulamalar() {
        try {
            File file = new File(getFilesDir(), "uygulama_kisit.json");
            if (file.exists()) {
                String jsonData = FileUtils.readFileToString(file, "UTF-8");
                JSONArray jsonArray = new JSONArray(jsonData);
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                    String packageName = jsonObject.optString("uygulama_adi");
                    int kisitDurumu = jsonObject.optInt("kisit");
                    if (kisitDurumu == 1) {
                        kisitliUygulamalar.add(packageName);
                    }
                }
            }
        } catch (IOException | JSONException e) {
            e.printStackTrace();
        }
    }
}
