import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

abstract final class AppCheckService {
  static Future<void> init() async {
    // Web kontrolü (Senin kodundaki gibi)
    if (kIsWeb) return;

    await FirebaseAppCheck.instance.activate(
      // Eski: providerAndroid: AndroidPlayIntegrityProvider()
      // YENİ TİP: androidProvider: AndroidProvider.playIntegrity
      androidProvider:
          kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,

      // iOS için
      appleProvider:
          kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
    );
  }
}
