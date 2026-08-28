// Özel Flutter web önyükleme betiği.
//
// Varsayılan (otomatik üretilen) flutter_bootstrap.js, CanvasKit motorunu
// Google'ın gstatic.com CDN'inden indirmeye çalışır. Bu CDN bazı
// ağlarda/ISS'lerde erişilemez ya da yavaş olabiliyor — engellendiğinde
// Flutter motoru hiç başlamıyor ve sayfa tamamen boş/bembeyaz kalıyor (veri
// sorunu değil, motor hiç yüklenmiyor). Bu dosya `flutter build web`
// tarafından otomatik olarak şablon değişkenleriyle doldurulur; burada tek
// farkımız CanvasKit'i her zaman uygulamayla birlikte
// derlenen yerel canvaskit/ klasöründen yüklemeye zorlamak, dış CDN'e hiç
// bağımlı kalmadan.
{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  },
  config: {
    canvasKitBaseUrl: "canvaskit/"
  }
});
