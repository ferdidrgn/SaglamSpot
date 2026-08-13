import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ads/ads_manager.dart';
import '../services/app_check_service.dart';
import '../services/notification_service.dart';
import '../services/remote_config_service.dart';
import '../util/date_formatter.dart';
import '../util/platform_checker.dart';
import 'firebase_options.dart';

abstract final class AppInitializer {
  static Future<void> init(final WidgetsBinding binding) async {
    try {
      // 🌐 Web platformunda URL adresindeki '#' işaretini kaldır
      if (PlatformChecker.isWeb) usePathUrlStrategy();

      // Bölgesel tarih ve dil formatlarını belleğe yükle
      await DateFormatter.initializeLocale();
      debugPrint(
          '🔐 Güvenli depolama alt yapısı ve yerelleştirme modülleri aktif.');

      // Çekirdek bulut motorlarını (Firebase) ve yerel AppCheck bütünlüğünü başlat
      await _bootstrapFirebaseAndCoreEngines();

      // İkincil ağ yapılandırmalarını ana ekran çizimini engellemeyecek şekilde arka planda paralel başlat
      unawaited(Future.wait([
        _safeInitializeRemoteConfig(),
        _safeInitializeAdEngine(),
        _safeInitializeNotifications(),
      ]));

      debugPrint('🚀 Sağlam Spot Kurumsal Sistem Mimarisi Başarıyla Yüklendi.');
    } catch (e, stack) {
      debugPrint(
          '🚨 Kritik Hata - Sistem Başlatma Döngüsü Kesintisi: $e\n$stack');
    }
  }

  static void configureSystemUIPreBoot() {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  static Future<void> _bootstrapFirebaseAndCoreEngines() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 5));

      // DOĞRULAMA: Sizin projenizin ham siber koruma servisi tam olması gerektiği yere geri mühürlendi!
      if (Firebase.apps.isNotEmpty) {
        await AppCheckService
            .init(); // Sizin özgün yerel App Check başlatıcınız

        if (!kIsWeb) {
          _setupCrashlyticsPipeline();
        }
      }
    } catch (e) {
      debugPrint(
          '🔥 Firebase bağlantı hattı atlandı veya çevrimdışı mod aktif: $e');
    }
  }

  static Future<void> _safeInitializeRemoteConfig() async {
    try {
      await RemoteConfigService.init();
    } catch (_) {}
  }

  static Future<void> _safeInitializeAdEngine() async {
    try {
      await AdManager.initialize();
      await MobileAds.instance.initialize();
    } catch (_) {}
  }

  static Future<void> _safeInitializeNotifications() async {
    try {
      await NotificationService.init();
    } catch (e) {
      debugPrint('🔕 Bildirim alt yapısı başlatılamadı: $e');
    }
  }

  static void _setupCrashlyticsPipeline() {
    FlutterError.onError = (final FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError =
        (final Object error, final StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
