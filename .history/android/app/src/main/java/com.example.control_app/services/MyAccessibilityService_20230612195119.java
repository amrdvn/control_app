import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Set;

public class RestrictionService extends Service {
    private static final String FILE_NAME = "uygulama_kisit.json";
    private Set<String> kisitliUygulamalar = new HashSet<>();

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        loadKisitliUygulamalar(getApplicationContext(), FILE_NAME);

        return START_STICKY;
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        // Uygulama kapatıldığında burası çalışır
        stopSelf();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void loadKisitliUygulamalar(Context context, String fileName) {
        String json = null;
        try {
            File file = new File(context.getExternalFilesDir(null), fileName);
            FileInputStream fis = new FileInputStream(file);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fis));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
            json = stringBuilder.toString();
            bufferedReader.close();
            fis.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        if (json != null) {
            try {
                JSONArray jsonArray = new JSONArray(json);
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                    String uygulamaAdi = jsonObject.getString("uygulama_adi");
                    int kisit = jsonObject.getInt("kisit");

                    if (kisit == 1) {
                        kisitliUygulamalar.add(uygulamaAdi);
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private void showToast(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }
}
