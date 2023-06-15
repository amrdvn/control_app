package com.example.control_app;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class MyAccessibilityService extends Service {
    private static final String FILE_NAME = "uygulama_kisit.json";

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String json = loadJSONFromAsset(getApplicationContext(), FILE_NAME);
        if (json != null) {
            try {
                JSONArray jsonArray = new JSONArray(json);
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                    String uygulamaAdi = jsonObject.getString("uygulama_adi");
                    int kisit = jsonObject.getInt("kisit");

                    if (kisit == 1) {
                        String mesaj = uygulamaAdi + " uygulaması kısıtlı olarak açıldı.";
                        showToast(getApplicationContext(), mesaj);
                       // Fluttertoast.showToast(msg: mesaj);
                       showToast(getApplicationContext(), "mesajjjjjjjj");
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private String loadJSONFromAsset(Context context, String fileName) {
        String json = null;
        try {
            InputStream is = context.getAssets().open(fileName);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
            json = stringBuilder.toString();
            bufferedReader.close();
            is.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return json;
    }

    private void showToast(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }
}
