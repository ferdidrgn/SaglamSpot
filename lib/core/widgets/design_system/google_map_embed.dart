// Koşullu Dışa Aktarma: Derleyici, çalıştığı platforma göre bu iki
// dosyadan sadece birini dışa (export) aktaracaktır.
// Web derlemesinde gerçek, canlı bir Google Haritalar <iframe>'i DOM'a
// gömülür (API anahtarı gerektirmeyen `output=embed` yöntemiyle). Mobil
// (io) derlemesinde ise dokununca native harita uygulamasını açan, aynı
// görsel dili taşıyan bir önizleme kartı gösterilir — iframe mobilde
// WebView gerektirir ve kullanıcı zaten native haritayı tercih eder.

export 'native/google_map_embed_stub.dart'
    if (dart.library.js) 'native/google_map_embed_web.dart'
    if (dart.library.io) 'native/google_map_embed_stub.dart';
