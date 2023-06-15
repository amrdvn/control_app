import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;

public class MyAccessibilityService extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Arka planda çalışırken hangi uygulama açıksa adını alıp Flutter tarafına iletiyoruz.
        ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        String foregroundApp = activityManager.getRunningTasks(1).get(0).topActivity.getPackageName();

        // İsmi Flutter'a iletmek için sonuç alıcısına gönderiyoruz.
        Bundle resultData = new Bundle();
        resultData.putString("foregroundApp", foregroundApp);
        ResultReceiver resultReceiver = getIntent().getParcelableExtra("resultReceiver");
        resultReceiver.send(0, resultData);

        // Arka planda çalışan bileşeni sonlandırıyoruz.
        finish();
    }
}
