package com.ferdidrgn.saglamspot

import android.os.Bundle
import android.view.WindowManager
import androidx.activity.EdgeToEdge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.ferdidrgn.saglamspot/security"

    override fun onCreate(savedInstanceState: Bundle?) {
        // 💡 Android 15 ve sonrası için sistemi geriye dönük uyumlu şekilde uçtan uca ekrana zorlar
        EdgeToEdge.enable(this)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "enableSecureMode") {
                // 🛡️ Ekran görüntüsü ve kaydını engelleme zırhı
                activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                result.success(true)
            } else result.notImplemented()
        }
    }
}