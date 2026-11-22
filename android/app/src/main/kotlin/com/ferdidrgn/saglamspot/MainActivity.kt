package com.ferdidrgn.saglamspot

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.content.ComponentName
import android.content.pm.PackageManager
import androidx.core.view.WindowCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.saglamspot/app_icon")
            .setMethodCallHandler { call, result ->
                if (call.method != "setAppLogo") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val useIllustrated = call.arguments == "illustrated"
                val selected = if (useIllustrated) ".LauncherIllustrated" else ".LauncherLuxe"
                val other = if (useIllustrated) ".LauncherLuxe" else ".LauncherIllustrated"
                try {
                    packageManager.setComponentEnabledSetting(
                        ComponentName(packageName, packageName + selected),
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP,
                    )
                    packageManager.setComponentEnabledSetting(
                        ComponentName(packageName, packageName + other),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP,
                    )
                    result.success(null)
                } catch (error: Exception) {
                    result.error("APP_ICON_UPDATE_FAILED", error.localizedMessage, null)
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Native katmanda tam ekran geçiş pencerelerini temizle
        WindowCompat.setDecorFitsSystemWindows(window, false)

        super.onCreate(savedInstanceState)

        // HER API düzeyinde çalışan tek yöntem: sistem çubuklarını ŞEFFAF
        // yap, Flutter'ın kendi içeriği (Scaffold/AtelierBackground zemin
        // rengi) onların ALTINDA zaten tam ekran boyandığı için görünür
        // olur. window.statusBarColor/navigationBarColor setter'ları
        // Android 15'te YOK SAYILIYOR demek "hata veriyor" değil — hiçbir
        // şey yapmıyor, zararsız; Android 15 zaten zorunlu kenar-kenar ve
        // kendiliğinden şeffaf. Eski sürümlerde (API 21-34) ise bu satırlar
        // olmadan çubuklar varsayılan OPAK SİYAH kalıyordu — asıl "navbar/
        // statusbar simsiyah" hatasının kök nedeni buydu. SADECE opak/sabit
        // bir RENK (ör. uygulamanın krem/kahve tonu) atamak "sonlandırılmış
        // API" uyarısını tetikliyor; ŞEFFAF (Color.TRANSPARENT) atamak
        // kenar-kenar görünümün ta kendisi ve önerilen/güncel yöntemdir.
        window.statusBarColor = Color.TRANSPARENT
        window.navigationBarColor = Color.TRANSPARENT

        // API 29 (Q) öncesinde sistem bu çubukların arkasına otomatik bir
        // yarı saydam karartma (scrim) ekler; bu da içerik şeffaf olsa bile
        // çubukları griye/siyaha yakın gösterir. Q+ bunu native olarak
        // kapatabiliyoruz, böylece gerçek içerik rengi hiçbir filtre olmadan
        // görünür.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.isNavigationBarContrastEnforced = false
            window.isStatusBarContrastEnforced = false
        }
    }
}
