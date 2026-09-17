import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '../ads/ads_manager.dart';
import '../services/app_check_service.dart';
import '../services/firebase_feature_prefs.dart';
import '../services/notification_service.dart';
import '../services/onboarding_cache.dart';
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

      // Admin > Firebase Servisleri ekranından değiştirilen Çökme Raporu/
      // Analitik tercihini Firebase'e bağlanmadan ÖNCE oku — SDK'lara bu
      // tercihi Firebase başlatılır başlatılmaz uygulayabilelim diye.
      await FirebaseFeaturePrefs.load();

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
      // statusBarColor/systemNavigationBarColor (rengi 'transparent' dahi
      // olsa) native tarafta artık kullanımdan kaldırılmış
      // Window.setStatusBarColor/setNavigationBarColor'ı tetikliyor — Android
      // 15+ (uçtan uca zorunlu) cihazlarda Play Console bunu "desteği
      // sonlandırılmış API kullanımı" olarak işaretliyor. Renkler null
      // bırakılıyor; uçtan uca görünüm zaten MainActivity'deki
      // WindowCompat.setDecorFitsSystemWindows(window, false) + aşağıdaki
      // SystemUiMode.edgeToEdge ile sağlanıyor. Sadece ikon parlaklığı
      // (deprecated olmayan WindowInsetsController yoluyla) ayarlanıyor.
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
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

        // Admin ekranından kayıtlı Çökme Raporu/Analitik tercihini SDK'lara
        // bildir — kullanıcı bir önceki oturumda kapattıysa bu oturumda da
        // kapalı kalsın.
        await FirebaseAnalytics.instance
            .setAnalyticsCollectionEnabled(FirebaseFeaturePrefs.analyticsEnabled);

        if (!kIsWeb) {
          await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
              FirebaseFeaturePrefs.crashlyticsEnabled);
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
      // AdManager.initialize() zaten sadece mobilde MobileAds'i başlatıyor
      // (bkz. core/ads/ads_manager.dart) — burada tekrar çağırmak web'de
      // desteklenmeyen bir platform kanalını (google_mobile_ads) korumasız
      // şekilde tetikliyor ve konsola "MissingPluginException" atıyordu.
      await AdManager.initialize();
    } catch (_) {}
  }

  static Future<void> _safeInitializeNotifications() async {
    // İlk açılışta (native + ev içi tanıtım henüz gösterilmemiş) bildirim
    // izni isteğini BURADA değil, onboarding tamamlandığı anda istiyoruz
    // (bkz. HouseWalkthroughOnboardingScreen._finish) — aksi halde kullanıcı
    // uygulamanın arayüzünü hiç görmeden ilk karede sistem izin diyaloğuyla
    // karşılaşıyordu. Web'de onboarding hiç gösterilmediği için (bkz.
    // app_router.dart) ve zaten onboarding'i görmüş cihazlarda davranış
    // DEĞİŞMEDEN aynı şekilde burada, uygulama açılışında istenir.
    if (!kIsWeb && !OnboardingCache.hasSeenOnboarding) return;
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
