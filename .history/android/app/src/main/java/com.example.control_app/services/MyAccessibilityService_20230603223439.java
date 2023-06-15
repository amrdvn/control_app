package com.example.control_app.services;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.view.accessibility.AccessibilityEvent;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MyAccessibilityService extends AccessibilityService {

    private List<String> kisitliUygulamalar = new ArrayList<>();

    @Override
public void onCreate() {
    super.onCreate();
    parseKisitliUygulamalar();
    Toast.makeText(this, "MyAccessibilityService oluşturuldu", Toast.LENGTH_SHORT).show();
}



    @Override
protected void onServiceConnected() {
    super.onServiceConnected();
    AccessibilityServiceInfo info = getServiceInfo();
    info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
    info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
    info.flags |= AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
    info.flags |= AccessibilityServiceInfo.FLAG_REQUEST_ENHANCED_WEB_ACCESSIBILITY;
    info.flags |= AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS;
    setServiceInfo(info);
}




@Override
public void onAccessibilityEvent(AccessibilityEvent event) {
    if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
        CharSequence packageName = event.getPackageName();
        if (packageName != null && kisitliUygulamalar.contains(packageName.toString())) {
            // Uygulama kısıtlı, açılmasını engelleyin ve uyarı verin
            Toast.makeText(this, "Bu uygulama kısıtlıdır.", Toast.LENGTH_SHORT).show();
            performGlobalAction(GLOBAL_ACTION_HOME); // Ana ekrana dön
        }
    }
}




    @Override
    public void onInterrupt() {
    }

    private void parseKisitliUygulamalar() {
        try {
                File file = new File(getExternalFilesDir(null), "uygulama_kisit.json");
            if (file.exists()) {
                FileInputStream fileInputStream = new FileInputStream(file);
                byte[] buffer = new byte[(int) file.length()];
                fileInputStream.read(buffer);
                fileInputStream.close();
                String jsonData = new String(buffer, "UTF-8");
                Toast.makeText(this, "Dosya İçeriği: " + jsonData, Toast.LENGTH_SHORT).show(); // Ekrana yazdırma işlemi
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
            Toast.makeText(this, "Kısıtlı uygulamalar okunamadı: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }
}
