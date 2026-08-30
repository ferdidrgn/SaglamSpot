// Koşullu Dışa Aktarma: derleyici, çalıştığı platforma göre bu üç
// dosyadan sadece birini dışa aktarır. Web derlemesinde mobil-özel
// `google_mobile_ads` paketine hiç dokunulmaz — NativeAdProductCard'ın
// (ve dolayısıyla google_mobile_ads'in) kodu web JS paketine hiç girmez.
// Önceden bu seçim çalışma zamanında (PlatformChecker.isWeb ile) yapılıyordu;
// bu doğru render'ı sağlıyordu ama google_mobile_ads'in kodu yine de web
// paketine dahil oluyordu, çünkü kaynak dosyada hâlâ statik olarak
// erişilebiliyordu.
export 'native_ad_card_stub.dart'
    if (dart.library.js) 'native_ad_card_web.dart'
    if (dart.library.io) 'native_ad_card_mobile.dart';
