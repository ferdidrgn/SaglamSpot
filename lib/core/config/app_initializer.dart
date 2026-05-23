import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safe_device/safe_device.dart';
import '../ads/ads_manager.dart';
import '../services/app_check_service.dart';
import '../services/remote_config_service.dart';
import '../util/date_formatter.dart';
import '../util/platform_checker.dart';
import 'firebase_options.dart';

abstract final class AppInitializer {
  // Native Android kanalını tanımlıyoruz
  static const MethodChannel _securityChannel =
      MethodChannel('com.ferdidrgn.saglamspot/security');

  static Future<bool> init() async {
    // 1. Flutter engine başlat
    WidgetsFlutterBinding.ensureInitialized();

    // 🛡️ GÜVENLİK ADIMI: Ekran Görüntüsü, Kaydını Engelle ve Root Kontrolü
    if (!PlatformChecker.isWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        // Platform kanalı üzerinden Android'e FLAG_SECURE emri gönderiyoruz (Aşağıdaki 2. adıma bakın)
        await _securityChannel.invokeMethod('enableSecureMode');
      } catch (e) {
        debugPrint('🛡️ Native Güvenlik Kanalı Hatası: $e');
      }

      // Root ve Sahte Konum Kontrolü
      try {
        bool isJailBroken = await SafeDevice.isJailBroken;
        bool isMockLocation = await SafeDevice.isMockLocation;

        if (isJailBroken || isMockLocation) {
          return false;
        }
      } catch (e) {
        debugPrint('🛡️ Güvenlik taraması yapılamadı: $e');
      }
    }

    // 2. Web URL stratejisi (# olmadan)
    if (PlatformChecker.isWeb) usePathUrlStrategy();

    // 3. Tarih/saat locale
    await DateFormatter.initializeLocale();

    // 4. Firebase — ÖNCELİKLİ
    await _initFirebase();

    // 5. RemoteConfig
    await RemoteConfigService.init();

    // 6. AdMob
    if (!kIsWeb) {
      await AdManager.initialize();
      await MobileAds.instance.initialize();
    } else {
      AdManager.initialize();
      MobileAds.instance.initialize();
    }

    // 7. AppCheck
    if (Firebase.apps.isNotEmpty) {
      await AppCheckService.init();
      if (!kIsWeb) _setupCrashlytics();
    }

    // 8. Sistem UI
    _configureSystemUI();

    debugPrint('🚀 Sağlam Spot hazır.');
    return true;
  }

  static Future<void> _initFirebase() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        debugPrint('🔥 Firebase zaten başlatılmış.');
        return;
      }
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 15));
      debugPrint('🔥 Firebase bağlandı.');
    } catch (e) {
      debugPrint('🔥 Firebase başlatma hatası: $e');
    }
  }

  static void _setupCrashlytics() {
    FlutterError.onError = (final errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (final error, final stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void _configureSystemUI() {
    if (!PlatformChecker.isWeb) {
      // Android 15+ uyumluluğu için desteği sonlandırılmış renk parametrelerini kaldırdık
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
      // Sistemi uçtan uca ekran moduna geçirir
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}
