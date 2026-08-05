// Koşullu Dışa Aktarma: Derleyici, çalıştığı platforma göre
// bu iki dosyadan sadece birini dışa (export) aktaracaktır.
// Web derlemesinde gerçek <ins class="adsbygoogle"> DOM enjeksiyonu yapılır,
// mobil (io) derlemesinde ise boş bir widget döner (mobilde AdMob kullanılıyor).

export 'native/real_adsense_ad_stub.dart'
    if (dart.library.js) 'native/real_adsense_ad_web.dart'
    if (dart.library.io) 'native/real_adsense_ad_stub.dart';
