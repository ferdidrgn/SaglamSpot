import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_gate_provider.dart';
import 'ads_manager.dart';
import '../common/enum/enums.dart';

/// Kullanıcıyı boğmadan ARA SIRA gösterilen geçiş (interstitial) reklamı.
///
/// Mantık: kullanıcı art arda [_kOpenThreshold] ürün detay sayfası
/// kapattığında (bkz. ProductDetailPage.dispose) BİR KEZ interstitial
/// gösterilir, sayaç sıfırlanır — bir sonraki eşiğe kadar tekrar
/// gösterilmez. Basit bir in-memory sayaç yeterli (session ömrü boyunca
/// yaşar, aşırı mühendislik yapılmadı — SharedPreferences'a yazmaya
/// gerek yok, uygulama yeniden açıldığında sıfırdan başlaması sorun
/// değil).
///
/// SADECE native (Android/iOS) — AdMob interstitial web'de çalışmaz, web
/// tarafında zaten AdSense banner/native slot'lar gösteriliyor (bkz.
/// AdsenseBanner/PlatformNativeAdSlot).
final class InterstitialAdManager {
  InterstitialAdManager._internal();

  static final InterstitialAdManager instance =
      InterstitialAdManager._internal();

  /// Art arda kaç ürün detay sayfası kapatıldığında bir interstitial
  /// gösterileceği.
  static const int _kOpenThreshold = 4;

  int _closedCount = 0;
  InterstitialAd? _ad;
  bool _isLoading = false;
  bool _isShowing = false;

  /// Önceden yükleme — uygulama açılışında veya bir ürün detay sayfası
  /// ilk açıldığında çağrılabilir; eşiğe ulaşıldığında reklamın hazır
  /// olma ihtimalini artırır. Reklamlar kapalıysa (RemoteConfig VEYA
  /// `ads_removed`) veya web'deyse hiçbir şey yapmaz.
  void preload() {
    if (kIsWeb || !AdGateCache.adsEnabled) return;
    _load();
  }

  void _load() {
    if (kIsWeb || _isLoading || _ad != null || !AdGateCache.adsEnabled) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AdManager.getAdUnitId(AdUnitType.interstitial),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (final ad) {
          _ad = ad;
          _isLoading = false;
          _ad!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (final dismissedAd) {
              dismissedAd.dispose();
              _ad = null;
              _isShowing = false;
              // Bir sonraki eşik için sessizce yeniden hazırla.
              _load();
            },
            onAdFailedToShowFullScreenContent: (final failedAd, final _) {
              failedAd.dispose();
              _ad = null;
              _isShowing = false;
              _load();
            },
          );
        },
        onAdFailedToLoad: (final error) {
          _isLoading = false;
          _ad = null;
          debugPrint('⚠️ Interstitial yükleme hatası: ${error.message}');
        },
      ),
    );
  }

  /// Bir ürün detay sayfası kapatıldığında (bkz.
  /// ProductDetailPage.dispose) çağrılır. Sayaç eşiğe ulaştıysa VE reklam
  /// hazırsa geçiş reklamını gösterir, sayacı sıfırlar; değilse sessizce
  /// sayar ve/veya bir sonraki gösterim için arka planda reklamı
  /// hazırlar.
  void onProductDetailClosed() {
    if (kIsWeb || !AdGateCache.adsEnabled || _isShowing) return;

    _closedCount++;
    if (_closedCount < _kOpenThreshold) {
      _load(); // Arka planda sessizce hazırla — kullanıcıyı bekletmeden.
      return;
    }

    _closedCount = 0;

    if (_ad == null) {
      // Reklam henüz hazır değilse bu seferi atla (kullanıcıyı bekletme);
      // bir sonraki eşikte tekrar denenir.
      _load();
      return;
    }

    _isShowing = true;
    _ad!.show();
  }
}
