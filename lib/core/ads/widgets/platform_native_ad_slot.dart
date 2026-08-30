// Koşullu Dışa Aktarma: derleyici, çalıştığı platforma göre bu üç
// dosyadan sadece birini dışa aktarır — web derlemesi AdNativeWidget'a
// (ve dolayısıyla google_mobile_ads paketine) hiç dokunmaz. Web'de zaten
// ayrı bir AdSense birimi gösteriliyor, bu yüzden web sürümü boş widget
// döner.
export 'platform_native_ad_slot_stub.dart'
    if (dart.library.js) 'platform_native_ad_slot_web.dart'
    if (dart.library.io) 'platform_native_ad_slot_mobile.dart';
