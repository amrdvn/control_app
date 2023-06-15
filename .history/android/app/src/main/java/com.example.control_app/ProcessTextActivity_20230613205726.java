package com.dcom.example.control_app;

import com.divyanshushekhar.flutter_process_text.FlutterProcessTextPlugin;
import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;

public class ProcessTextActivity extends FlutterActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        boolean isAppRunning = MainActivity.getIsAppRunning();
        FlutterProcessTextPlugin.listenProcessTextIntent(isAppRunning);
    }
}
