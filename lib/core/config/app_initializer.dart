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
import '../services/remote_config_service.dart';
import '../util/date_formatter.dart';
import '../util/platform_checker.dart';
import 'firebase_options.dart';

abstract final class AppInitializer {
  static Future<void> init(final WidgetsBinding binding) async {
    try {
      // Web platformundaki arama motoru botları için URL adresindeki gereksiz kare (#) işaretlerini kaldır
      if (PlatformChecker.isWeb) {
        usePathUrlStrategy();
      }

      // Bölgesel tarih ve dil formatlarını belleğe yükle
      await DateFormatter.initializeLocale();
      debugPrint(
          '🔐 Güvenli depolama alt yapısı ve yerelleştirme modülleri aktif.');

      // Çekirdek bulut motorlarını katı zaman aşımı süreleri ile sisteme bağla
      await _bootstrapFirebaseAndCoreEngines();

      // İkincil ağ yapılandırmalarını ana ekran çizimini engellemeyecek şekilde asenkron (arka planda) başlat
      unawaited(Future.wait([
        _safeInitializeRemoteConfig(),
        _safeInitializeAdEngine(),
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

      if (Firebase.apps.isNotEmpty) {
        await AppCheckService
            .init(); // Hacker ve sahte istek koruma kalkanı (App Check)
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
