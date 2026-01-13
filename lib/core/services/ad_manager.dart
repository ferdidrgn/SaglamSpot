import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:saglamspot/core/util/platform_checker.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();

  factory AdManager() => _instance;

  AdManager._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (PlatformChecker.isMobile) {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    }
  }

  String bannerId() {
    if (kDebugMode)
      return PlatformChecker.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    else
      return PlatformChecker.isAndroid
          ? 'ca-app-pub-5779807348211992/6454721883'
          : 'YOUR_IOS_BANNER_ID';
  }

  String nativeId() {
    if (kDebugMode)
      return PlatformChecker.isAndroid
          ? "ca-app-pub-3940256099942544/2247696110"
          : "ca-app-pub-3940256099942544/2247696110";
    else
      return PlatformChecker.isAndroid
          ? 'ca-app-pub-5779807348211992/2655077678'
          : 'YOUR_IOS_NATIVE_ID';
  }

  // Web için AdSense Slot ID
  String adsenseId() {
    if (kDebugMode)
      return "1234567890"; // Test ID
    else
      return "YOUR_REAL_ADSENSE_SLOT_ID"; // Google AdSense'den aldığın ID
  }

  bool get isInitialized => _isInitialized;
}
