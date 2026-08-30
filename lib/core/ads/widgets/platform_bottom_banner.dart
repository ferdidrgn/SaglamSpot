// Koşullu Dışa Aktarma: derleyici, çalıştığı platforma göre bu üç
// dosyadan sadece birini dışa aktarır — web derlemesi AdBannerWidget'a
// (ve dolayısıyla google_mobile_ads paketine) hiç dokunmaz.
export 'platform_bottom_banner_stub.dart'
    if (dart.library.js) 'platform_bottom_banner_web.dart'
    if (dart.library.io) 'platform_bottom_banner_mobile.dart';
