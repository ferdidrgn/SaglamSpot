import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'revenue_cat_service.dart';

/// "6 Aylık Reklamsız Üyelik" için sadeleştirilmiş durum modeli. Tek doğru
/// kaynak RevenueCat'in customerInfo/entitlement mekanizmasıdır — burada
/// hiçbir satın alma bilgisi kalıcı olarak KENDİMİZ tutmuyoruz, sadece
/// [_AdsRemovedMirror] aracılığıyla SharedPreferences'a senkron okunabilir
/// bir ayna (mirror) bırakıyoruz (bkz. aşağıdaki not).
@immutable
class SubscriptionStatus {
  final bool isActive;
  final DateTime? expiresAt;

  const SubscriptionStatus({required this.isActive, this.expiresAt});

  static const none = SubscriptionStatus(isActive: false);
}

/// SharedPreferences anahtarı — `lib/core/ads/ad_gate_provider.dart` (BAŞKA
/// bir görevde eklenen, buradan KASITLI olarak dokunulmayan dosya) bu AYNI
/// anahtarı okuyarak reklamların gösterilip gösterilmeyeceğine karar verir.
/// Buradaki provider, RevenueCat'ten dönen güncel durumu her sorguladığında
/// bu anahtarı günceller (aktifse true, süresi dolmuş/pasifse false) —
/// böylece iki özellik arasında DOSYA ÇAKIŞMASI olmadan, sadece ORTAK bir
/// SharedPreferences sözleşmesiyle senkronize olurlar.
const String kAdsRemovedPrefsKey = 'ads_removed';

/// [SubscriptionStatus]'u RevenueCat'ten okuyup expose eden Riverpod
/// notifier'ı. `build()` uygulama açılışında bir kez, `refresh()` ise satın
/// alma sonrası veya kullanıcı manuel yenilediğinde çağrılır.
class SubscriptionStatusNotifier extends AsyncNotifier<SubscriptionStatus> {
  @override
  Future<SubscriptionStatus> build() => _load();

  /// RevenueCat'ten güncel customerInfo'yu çeker, durumu hesaplar ve
  /// SharedPreferences'taki `ads_removed` aynasını günceller. Önceki değer
  /// ekranda kalsın diye (yanıp sönmesin) `state`'i baştan `loading`'e
  /// ÇEKMİYORUZ — sonuç gelince tek seferde günceller.
  Future<SubscriptionStatus> refresh() async {
    final status = await _load();
    state = AsyncData(status);
    return status;
  }

  /// Bir satın alma akışı [CustomerInfo] ile SONUÇLANDIĞINDA, ekstra bir ağ
  /// çağrısı beklemeden durumu ANINDA bu bilgiyle günceller (ör. satın alma
  /// sonrası buton/kart metninin gecikmeden "Aktif" göstermesi için).
  Future<SubscriptionStatus> applyCustomerInfo(
      final CustomerInfo customerInfo) async {
    final status = _statusFromCustomerInfo(customerInfo);
    await _syncAdsRemovedMirror(status.isActive);
    state = AsyncData(status);
    return status;
  }

  Future<SubscriptionStatus> _load() async {
    final customerInfo = await RevenueCatService.getCustomerInfo();
    final status = _statusFromCustomerInfo(customerInfo);
    await _syncAdsRemovedMirror(status.isActive);
    return status;
  }

  SubscriptionStatus _statusFromCustomerInfo(final CustomerInfo? info) {
    if (info == null) return SubscriptionStatus.none;
    return SubscriptionStatus(
      isActive: RevenueCatService.isRemoveAdsActive(info),
      expiresAt: RevenueCatService.removeAdsExpirationDate(info),
    );
  }

  Future<void> _syncAdsRemovedMirror(final bool isActive) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kAdsRemovedPrefsKey, isActive);
    } catch (e) {
      debugPrint('💳 ads_removed SharedPreferences yazma hatası: $e');
    }
  }
}

final subscriptionStatusProvider =
    AsyncNotifierProvider<SubscriptionStatusNotifier, SubscriptionStatus>(
        SubscriptionStatusNotifier.new);
