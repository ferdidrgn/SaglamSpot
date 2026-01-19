import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

abstract final class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 6),
        ),
      );

      await _remoteConfig.fetchAndActivate();
      debugPrint('☁️ RemoteConfig hazır.');
    } catch (e) {
      debugPrint('☁️ RemoteConfig hata: $e');
    }
  }

  // 🔑 ÖRNEK FLAG
  static bool get adsEnabled => _remoteConfig.getBool('ads_enabled');
}
