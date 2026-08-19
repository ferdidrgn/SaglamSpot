// Koşullu Dışa Aktarma: Derleyici, çalıştığı platforma göre bu iki
// dosyadan sadece birini dışa (export) aktaracaktır — RealAdsenseAd'daki
// (lib/core/ads/widgets/real_adsense_ad.dart) ile aynı desen.
// Web derlemesinde gerçek bir <iframe> ile canlı Google Haritalar gömülür,
// mobil (io) derlemesinde ise tıklanınca haritalar uygulamasını açan bir
// kart döner.

export 'native/google_maps_embed_stub.dart'
    if (dart.library.js) 'native/google_maps_embed_web.dart'
    if (dart.library.io) 'native/google_maps_embed_stub.dart';
