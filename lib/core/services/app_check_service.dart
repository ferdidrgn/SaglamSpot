import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

abstract final class AppCheckService {
  /// AppCheck'i başlatır. Hata olursa uygulamayı bloklamaz.
  /// Play Store'da playIntegrity, debug'da debug token kullanılır.
  static Future<void> init() async {
    try {
      if (kIsWeb) {
        const siteKey = String.fromEnvironment('RECAPTCHA_V3_SITE_KEY');
        if (siteKey.isEmpty) {
          debugPrint('⚠️ Web App Check site key eksik; provider başlatılmadı.');
          return;
        }
        await FirebaseAppCheck.instance
            .activate(webProvider: ReCaptchaV3Provider(siteKey))
            .timeout(const Duration(seconds: 8));
        debugPrint('🛡️ Web App Check başarıyla aktif.');
        return;
      }

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
