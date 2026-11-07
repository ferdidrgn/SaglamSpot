// Bu dosya ESKİ Flutter PWA service worker'ının YERİNİ alıyor — Flutter
// web HER ZAMAN bu sabit yola (/flutter_service_worker.js, kök dizin)
// kaydeder, bu bir konvansiyondur, değiştirilemez. saglamspotcu.web.app
// artık web-genesis'i sunuyor ama bu adresi daha önce (Flutter'ın
// canlıdayken) HİÇ ziyaret etmiş olan tarayıcılarda eski SW hâlâ kayıtlı
// kalabiliyor; eğer o SW "cache-first"/"cache-only" bir fetch stratejisi
// kullanıyorsa, sayfanın KENDİSİ (ve layout.js'teki kill-switch script'i
// dahil) ağdan hiç çekilmeden eski/bayat bir sürüm sunulmaya devam eder —
// "hiçbir buton çalışmıyor, yukarı çık bile çalışmıyor" şikâyetlerinin
// kök nedeni budur (gerçek kullanıcı geri bildirimiyle yakalandı).
//
// Tarayıcılar kayıtlı bir SW'nin script dosyasını PERİYODİK OLARAK
// (tipik olarak gezinmede, son kontrolden ~24 saat geçtiyse) yeniden
// çeker — ve bu kontrol SW'NİN KENDİ fetch handler'ını BYPASS eder
// (W3C Service Worker spesifikasyonunun KASITLI bir tasarım kararı,
// tam olarak bu kısır döngüyü kırmak için). Yani eski SW sayfayı
// önbellekten servis etmeye devam etse bile, tarayıcı YİNE DE bu
// dosyayı doğrudan sunucudan taze çeker; içerik byte-farklı olduğu
// için yeni bir SW olarak kurulur, hemen devreye girip TÜM önbellekleri
// temizler, kendini siler ve açık sekmeleri yeniler — kullanıcının
// elle "site verilerini temizle" yapmasına GEREK KALMADAN.
self.addEventListener("install", () => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
        .then((keys) => Promise.all(keys.map((key) => caches.delete(key))))
        .then(() => self.registration.unregister())
        .then(() => self.clients.matchAll({type: "window"}))
        .then((clients) => {
          clients.forEach((client) => client.navigate(client.url));
        }),
  );
});
