import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.ResultReceiver;

public class BackgroundAppInfoReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent != null && intent.hasExtra("resultReceiver")) {
            ResultReceiver resultReceiver = intent.getParcelableExtra("resultReceiver");

            // Arka planda çalışan uygulamanın adını alıp sonuç alıcısına gönderiyoruz.
            ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            String foregroundApp = activityManager.getRunningTasks(1).get(0).topActivity.getPackageName();

            Bundle resultData = new Bundle();
            resultData.putString("foregroundApp", foregroundApp);
            resultReceiver.send(0, resultData);
        }
    }
}
