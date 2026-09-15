import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

abstract final class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  // 🔔 UI'ı tetikleyecek olan notifier
  static final ValueNotifier<bool> adsEnabledNotifier = ValueNotifier(true);

  static Future<void> init() async {
    try {
      // Varsayılan değerler
      await _remoteConfig.setDefaults({'adsEnabled': true});

      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(hours: 6),
      ));

      await _remoteConfig.fetchAndActivate();

      // Değeri güncelle
      adsEnabledNotifier.value = _remoteConfig.getBool('adsEnabled');
      debugPrint(
          '☁️ RemoteConfig hazır. adsEnabled: ${adsEnabledNotifier.value}');
    } catch (e) {
      debugPrint('☁️ RemoteConfig hata: $e');
    }
  }

  static bool get adsEnabled => adsEnabledNotifier.value;

  /// Admin > Firebase Servisleri sayfasındaki "Şimdi Güncelle" butonu için —
  /// [init]'in aksine varsayılanları/ayarları tekrar yazmaz, sadece Firebase
  /// Console'daki GÜNCEL değerleri yeniden çeker. Değerlerin KENDİSİ hâlâ
  /// sadece Console'dan değiştirilebilir — istemci SDK'sı bilerek salt
  /// okunur, burada sadece en güncel değeri görmeyi/yenilemeyi sağlıyoruz.
  static Future<bool> refresh() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      adsEnabledNotifier.value = _remoteConfig.getBool('adsEnabled');
      return activated;
    } catch (e) {
      debugPrint('☁️ RemoteConfig yenileme hatası: $e');
      return false;
    }
  }

  /// Ham parametre listesi — admin ekranında salt okunur gösterim için.
  static Map<String, RemoteConfigValue> get allValues => _remoteConfig.getAll();

  static DateTime get lastFetchTime => _remoteConfig.lastFetchTime;

  static RemoteConfigFetchStatus get lastFetchStatus =>
      _remoteConfig.lastFetchStatus;
}
