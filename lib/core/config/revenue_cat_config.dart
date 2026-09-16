/// RevenueCat API anahtarları — BURADAKİ DEĞERLER SAHTE/PLACEHOLDER'DIR.
///
/// Gerçek satın alma akışının çalışması için:
///   1) https://app.revenuecat.com adresinde bir hesap/proje aç (yoksa).
///   2) Projeye bu uygulamayı (Android + iOS) app olarak ekle.
///   3) RevenueCat panelinde "API Keys" bölümünden PLATFORMA ÖZEL
///      "Public app-specific API key"leri kopyala (Secret key DEĞİL —
///      istemci/mobil uygulamada SADECE public key kullanılır).
///   4) Aşağıdaki iki sabiti kendi anahtarlarınla değiştir:
///        iosApiKey     -> RevenueCat > Project > Apps > iOS app > API key
///        androidApiKey -> RevenueCat > Project > Apps > Android app > API key
///
/// Ayrıca RevenueCat dashboard'ında (kod tarafında BEKLENEN, burada
/// OLUŞTURULMAYAN) şu yapılandırma yapılmış olmalı:
///   - Entitlement: "remove_ads" adında bir entitlement oluşturulmalı.
///   - Bu entitlement'a, App Store Connect / Google Play Console'da
///     tanımlanmış "6 aylık reklamsız üyelik" aboneliğine karşılık gelen
///     ürün(ler) bağlanmalı.
///   - Bir Offering (ör. "default") içine bu paket "six_month"/benzeri bir
///     package identifier ile eklenmeli — RevenueCatService bu offering'in
///     paketlerini gezip 6 aylık paketi (package.packageType == sixMonth
///     veya identifier eşleşmesiyle) bulur, bkz. revenue_cat_service.dart.
///
/// Bu sabitler bilerek HARDCODE gerçek anahtar İÇERMİYOR — repo'ya gerçek
/// API key'lerin sızmaması için. Prod/staging derlemelerinde bu dosyayı
/// (veya --dart-define / ortam değişkeni tabanlı bir yapıyı) gerçek
/// değerlerle güncelle.
abstract final class RevenueCatConfig {
  /// RevenueCat > Project settings > API keys > Apple App Store (public key).
  static const String iosApiKey = 'TODO_REVENUECAT_IOS_KEY';

  /// RevenueCat > Project settings > API keys > Google Play Store (public key).
  static const String androidApiKey = 'TODO_REVENUECAT_ANDROID_KEY';

  /// Dashboard'da oluşturulması BEKLENEN entitlement kimliği.
  static const String removeAdsEntitlementId = 'remove_ads';
}
