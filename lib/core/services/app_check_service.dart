import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

abstract final class AppCheckService {
  /// AppCheck'i başlatır. Hata olursa uygulamayı bloklamaz.
  /// Play Store'da playIntegrity, debug'da debug token kullanılır.
  static Future<void> init() async {
    if (kIsWeb) return; // Web desteklenmiyor

    try {
      await FirebaseAppCheck.instance
          .activate(
            androidProvider: kReleaseMode
                ? AndroidProvider.playIntegrity
                : AndroidProvider.debug,
            appleProvider:
                kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
          )
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () => debugPrint('⚠️ AppCheck timeout — devam ediliyor'),
          );
      debugPrint('🛡️ AppCheck başarıyla aktif.');
    } catch (e) {
      // AppCheck başarısız olursa uygulama tamamen çalışmaya devam eder.
      // Firestore kurallarına göre erişim yine kısıtlanabilir.
      debugPrint('⚠️ AppCheck başlatma hatası (devam ediliyor): $e');
    }
  }
}
