import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;

public class MyAccessibilityService extends Activity {

    // Arka planda çalışan bileşene geçici bir aktivite olarak başlatılıyoruz.
ResultReceiver resultReceiver = new ResultReceiver(new Handler()) {
    @Override
    protected void onReceiveResult(int resultCode, Bundle resultData) {
        if (resultCode == 0 && resultData != null) {
            String foregroundApp = resultData.getString("foregroundApp");

            // Flutter tarafına elde ettiğimiz uygulama adını iletiyoruz.
            MethodChannel channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "app_info_channel");
            channel.invokeMethod("onForegroundAppChanged", foregroundApp);
        }
    }
};

Intent backgroundAppInfoIntent = new Intent(this, BackgroundAppInfoReceiver.class);
backgroundAppInfoIntent.putExtra("resultReceiver", resultReceiver);
startActivity(backgroundAppInfoIntent);

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
