package com.ferdidrgn.saglamspot

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()

        super.onCreate(savedInstanceState)

        // TargetSDK 37 / Android 15+ cihazlarda sistem navigasyon çubuklarının
        // şeffaflık ve kontrast korumalarını native düzeyde yönetir
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.isNavigationBarContrastEnforced = false
            window.isStatusBarContrastEnforced = false
        }
    }
}