import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reklamların bir abonelik/satın alma ("reklamları kaldır") ile
/// KAPATILIP kapatılmadığını tutan basit önbellek.
///
/// `ads_removed` anahtarı ŞİMDİLİK sadece OKUNUYOR — bu anahtarı gerçekten
/// `true` yapacak abonelik/RevenueCat entegrasyonu AYRI bir görev (bu
/// dosya o entegrasyonu YAPMAZ, sadece okuma altyapısını hazırlar).
///
/// Diğer önbelleklerle (bkz. ThemeModeCache/OnboardingCache) AYNI desen:
/// `load()` ile senkron bir varsayılan sağlanır — böylece widget ağacı
/// dışındaki sınıflar da (ör. InterstitialAdManager) `ref`/`context`
/// gerekmeden doğrudan [AdGateCache.adsEnabled] okuyabilir.
final class AdGateCache {
  AdGateCache._();

  static const String _key = 'ads_removed';
  static bool _adsRemoved = false;

  /// Reklamlar gösterilsin mi? Varsayılan — ve `ads_removed` anahtarı hiç
  /// yazılmamışsa (yeni kurulum, abonelik yok) — HER ZAMAN `true`, yani
  /// reklamlar gösterilir.
  static bool get adsEnabled => !_adsRemoved;

  /// main.dart'ta runApp'ten ÖNCE bir kez çağrılır (bkz. ThemeModeCache
  /// deseni) — ilk karede yanlış (reklamsız/reklamlı) durumun bir an
  /// görünüp değişmesini önlemek için.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _adsRemoved = prefs.getBool(_key) ?? false;
  }

  /// Abonelik/RevenueCat entegrasyonu (İLERİDE) satın alma/iptal sonrası
  /// bu değeri anlık olarak yeniden okumak için çağırabilir. Şimdilik
  /// hiçbir çağıran YOK — sadece okuma altyapısı hazır.
  static Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    _adsRemoved = prefs.getBool(_key) ?? false;
  }
}

/// [AdGateCache] üzerine ince bir Riverpod katmanı — reklam widget'larının
/// (`Consumer`/`ref.watch` ile) SharedPreferences değeri değiştiğinde
/// anlık olarak tepki verebilmesi için. Varsayılan `true` (reklamlar
/// gösterilir).
class AdsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => AdGateCache.adsEnabled;

  /// [AdGateCache.refresh] sonrası widget ağacını yeniden derletmek için
  /// çağrılır (ör. gelecekteki abonelik akışının satın alma sonrası
  /// tetikleyeceği nokta).
  Future<void> reload() async {
    await AdGateCache.refresh();
    state = AdGateCache.adsEnabled;
  }
}

/// Reklamlar gösterilsin mi? `false` ise TÜM reklam widget'ları
/// (AdsenseBanner, NativeAdCard, PlatformNativeAdSlot) ve
/// InterstitialAdManager hiçbir şey göstermez/yüklemez.
final adsEnabledProvider =
    NotifierProvider<AdsEnabledNotifier, bool>(AdsEnabledNotifier.new);
