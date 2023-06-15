package com.example.control_app
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.IBinder;

public class KillAppService extends Service {
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String packageName = intent.getStringExtra("package_name");
        if (packageName != null) {
            try {
                // Kill the app
                Process.killProcess(getPackageManager().getPackageInfo(packageName, 0).applicationInfo.uid);
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }
        return START_NOT_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
