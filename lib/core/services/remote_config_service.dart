import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

abstract final class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  // 🔔 UI'ı tetikleyecek olan notifier'lar
  static final ValueNotifier<bool> adsEnabledNotifier = ValueNotifier(true);

  /// Bakım modu — true olduğunda tüm uygulama "Bakımdayız" ekranına
  /// yönlendirilir (bkz. main.dart > RemoteConfigGate). Varsayılan false:
  /// Firebase Console'da hiç ayarlanmamış olsa bile uygulama normal
  /// çalışmaya devam eder.
  static final ValueNotifier<bool> maintenanceModeNotifier =
      ValueNotifier(false);

  /// Mağaza zorunlu güncelleme eşiği — kurulu sürüm bu değerden KESİN
  /// olarak eskiyse kullanıcı "Güncelleme Gerekli" ekranına yönlendirilir
  /// (bkz. [isUpdateRequired]). Varsayılan '0.0.0': hiçbir gerçek sürüm
  /// bundan eski olamayacağı için Console'da hiç ayarlanmamışsa zorunlu
  /// güncelleme asla tetiklenmez.
  static final ValueNotifier<String> forceUpdateMinVersionNotifier =
      ValueNotifier('0.0.0');

  static Future<void> init() async {
    try {
      // Varsayılan değerler
      await _remoteConfig.setDefaults({
        'adsEnabled': true,
        'maintenance_mode': false,
        'force_update_min_version': '0.0.0',
      });

      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(hours: 6),
      ));

      await _remoteConfig.fetchAndActivate();

      _applyFetchedValues();
      debugPrint(
          '☁️ RemoteConfig hazır. adsEnabled: ${adsEnabledNotifier.value}');
    } catch (e) {
      debugPrint('☁️ RemoteConfig hata: $e');
    }
  }

  static void _applyFetchedValues() {
    adsEnabledNotifier.value = _remoteConfig.getBool('adsEnabled');
    maintenanceModeNotifier.value = _remoteConfig.getBool('maintenance_mode');
    forceUpdateMinVersionNotifier.value =
        _remoteConfig.getString('force_update_min_version');
  }

  static bool get adsEnabled => adsEnabledNotifier.value;

  static bool get maintenanceMode => maintenanceModeNotifier.value;

  static String get forceUpdateMinVersion =>
      forceUpdateMinVersionNotifier.value;

  /// Admin > Firebase Servisleri sayfasındaki "Şimdi Güncelle" butonu için —
  /// [init]'in aksine varsayılanları/ayarları tekrar yazmaz, sadece Firebase
  /// Console'daki GÜNCEL değerleri yeniden çeker. Değerlerin KENDİSİ hâlâ
  /// sadece Console'dan değiştirilebilir — istemci SDK'sı bilerek salt
  /// okunur, burada sadece en güncel değeri görmeyi/yenilemeyi sağlıyoruz.
  static Future<bool> refresh() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      _applyFetchedValues();
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

  /// [currentVersion] (örn. PackageInfo.version, "1.2.3") [forceUpdateMinVersion]
  /// değerinden KESİN OLARAK daha eskiyse true döner. Basit "." ile ayrılmış
  /// sayısal parçalar (major.minor.patch) üzerinden karşılaştırma yapılır;
  /// build numarası ("+13" gibi) veya ön sürüm etiketleri yok sayılır.
  static bool isUpdateRequired(final String currentVersion) {
    final minVersion = forceUpdateMinVersion;
    if (minVersion.trim().isEmpty) return false;

    final current = _parseVersionParts(currentVersion);
    final min = _parseVersionParts(minVersion);
    for (var i = 0; i < 3; i++) {
      if (current[i] != min[i]) return current[i] < min[i];
    }
    return false;
  }

  static List<int> _parseVersionParts(final String value) {
    final parts = value.split('+').first.split('.');
    return List<int>.generate(
        3, (final i) => i < parts.length ? int.tryParse(parts[i]) ?? 0 : 0);
  }
}
