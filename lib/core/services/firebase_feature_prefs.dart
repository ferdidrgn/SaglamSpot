import 'package:shared_preferences/shared_preferences.dart';

/// Admin > Firebase Servisleri ekranındaki "Çökme Raporlarını Gönder" /
/// "Kullanım Analitiği Topla" anahtarlarının kalıcı tercihi. Firebase'in
/// kendi SDK'ları bu tercihi platformda kalıcı tutar (bkz.
/// `setCrashlyticsCollectionEnabled`/`setAnalyticsCollectionEnabled`), ama
/// biz de theme_mode_cache.dart ile AYNI desende kendi kopyamızı tutuyoruz —
/// hem admin ekranı açılır açılmaz doğru anahtar durumunu senkron
/// gösterebilsin, hem de her uygulama açılışında tercihi tekrar SDK'ya
/// bildirebilelim (bkz. AppInitializer).
final class FirebaseFeaturePrefs {
  FirebaseFeaturePrefs._();

  static const String _crashlyticsKey = 'fb_crashlytics_enabled';
  static const String _analyticsKey = 'fb_analytics_enabled';

  static bool _crashlyticsEnabled = true;
  static bool _analyticsEnabled = true;

  static bool get crashlyticsEnabled => _crashlyticsEnabled;
  static bool get analyticsEnabled => _analyticsEnabled;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _crashlyticsEnabled = prefs.getBool(_crashlyticsKey) ?? true;
    _analyticsEnabled = prefs.getBool(_analyticsKey) ?? true;
  }

  static Future<void> setCrashlyticsEnabled(final bool value) async {
    _crashlyticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_crashlyticsKey, value);
  }

  static Future<void> setAnalyticsEnabled(final bool value) async {
    _analyticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_analyticsKey, value);
  }
}
