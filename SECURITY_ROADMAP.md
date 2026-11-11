# Sağlam Spot güvenlik ve süreklilik planı

Bu belge, 2026-11-10 tarihli kaynak kodu denetimi ve güvenli dağıtım sonrası
kalan işleri takip etmek içindir. Canlı veritabanında silme/değiştirme saldırısı
yapılmamıştır.

## Tamamlanan savunmalar

- Web admin doğrulaması Firestore kontrolü hata verince güvenli varsayılan olarak
  `false` döner.
- Firestore kuralları admin olmayan hesapların ürün/kategori yazmasını engeller.
- Bildirim aboneliği dokümanlarının istemciden silinmesi kapatılmıştır.
- Storage ürün görselleri admin + JPEG + 10 MB + numaralı dosya adı ile sınırlıdır.
- Ürün görseli yükleme hatalarında orphan dosya temizliği ve boyut doğrulaması vardır.
- Bildirim ve deeplink rotaları harici URL, kontrol karakteri ve `/admin` geçişine
  kapalı güvenli listeyle sınırlandırılmıştır.
- Android release build artık debug anahtarıyla imzalanamaz; Android yedekleme ve
  cleartext trafik kapalıdır.
- FCM token ve tam deeplink değerleri üretim loguna yazılmaz.
- Web hosting için HSTS, nosniff, frame engeli, referrer ve permissions başlıkları
  yayımlanmıştır.
- Ürün silme kalıcı `delete()` yerine `archiveProduct` callable'ı ile
  `DeletedProduct` arşivine taşınır; `restoreProduct` ile geri alınabilir.
- Ürün oluşturma/düzenleme/arşivleme/geri yükleme işlemleri için append-only
  `admin_audit_logs` kayıtları Cloud Functions tarafından tutulur.
- Firestore günlük 14 haftalık backup schedule, PITR ve veritabanı silme koruması
  ile yapılandırılmıştır.
- Mobil/web istemci kodundan gömülü HMAC sırrı kaldırılmış; ürün ve sepet
  linkleri herkese açık veri olarak biçim doğrulamasıyla sınırlandırılmıştır.
- Web App Check kodu reCAPTCHA v3 site key ile çalışacak şekilde hazırlandı;
  Firebase Console kaydı ve enforcement ayarı gereklidir.
- Kalıcı silme yalnızca doğrulanmış ve `admins/{email}` dokümanında
  `canPermanentlyDelete: true` olan süper admin için callable + açık metin onayı
  ile kullanılabilir.
- Admin girişi e-posta doğrulaması yoksa doğrulama e-postası gönderip oturumu
  kapatır; Firestore/Storage admin yazmaları da doğrulanmış e-posta ister.

## Sıradaki uygulama sırası

### 1. Kullanıcıya tamamen açılmadan önce yapılacak manuel hesap ayarları

1. Firebase Authentication'da admin hesaplarında MFA açın ve normal kullanıcı
   hesaplarının admin olmadığını doğrulayın.
2. Firebase App Check'i önce izleme modunda, metrikler temizlendikten sonra
   Firestore ve Storage için zorunlu moda alın. Web için reCAPTCHA Enterprise
   sağlayıcısını kaydedin.
3. Android release keystore ve parolalarını rotate edin; parolaları yalnızca CI
   secret store'da tutun. `android/key.properties` repoya alınmamalıdır.
4. HMAC istemci kodundan kaldırıldı. Eski imzalı linkler uyumluluk için kabul
   edilebilir, yeni linkler secret taşımıyor.

### 2. Ürün silinmezliği ve izlenebilirlik

Ürün arşivleme ve geri yükleme backend'de tamamlandı. Admin panelinde arşiv
geri yükleme ekranı ayrıca eklenebilir; kalıcı silme şu an hiçbir istemci akışında
bulunmamalıdır.

Ürün oluşturma/düzenleme/silme, admin e-postası, zaman, değişen alanlar ve önceki
değer özeti Cloud Functions/Admin SDK ile `admin_audit_logs` koleksiyonuna
yazılmalı. İstemci bu koleksiyona yazamamalı; logların silinmesi de istemciye
kapalı olmalı.

> Bu uygulamada şu an bilet/satın alma modülü yok; mevcut korunması gereken veri
> ürün kataloğu ve admin işlemleridir. İleride bilet modülü eklenirse bilet
> değişimleri ayrı, append-only olay günlüğüne yazılmalıdır.

### 3. Yedekleme ve felaket kurtarma

- Firestore PITR'ı açın: kısa süreli, dakikaya yakın geri dönüş için.
- Günlük zamanlanmış Firestore export'u ayrı bir Cloud Storage bucket'ına alın;
  bucket için object versioning/retention ve farklı IAM kullanın.
- Kritik katalog değişikliklerinde ayrıca değişiklik snapshot'ı üretin.
- İki saatte bir yedek teknik olarak yapılabilir, fakat Firestore'un yerleşik
  zamanlanmış yedekleri günlük/haftalık çalışır. İki saatlik RPO gerekiyorsa
  Cloud Scheduler + Cloud Run/Functions export akışı ve maliyet limiti ayrıca
  tasarlanmalıdır.
- Ayda en az bir kez test projesine geri yükleme tatbikatı yapın; yedek almak
  tek başına geri dönebilirlik kanıtı değildir.

### 4. İzleme ve saldırı dayanıklılığı

- Firestore Data Access Audit Logs'u açıp ayrı log bucket/BigQuery'ye aktarın.
- Analytics ve görüntülenme sayaçlarını App Check + rate limit + backend
  aggregation arkasına taşıyın; ham olaylara TTL uygulayın.
- Haftalık orphan Storage dosyası taraması ve başarısız admin işlemi alarmı ekleyin.
- Playwright ve Firebase Emulator Rules Unit Testing ile girişsiz kullanıcı,
  normal kullanıcı, admin, çıkış sonrası geri tuşu, sınır boyutlu görsel ve
  XSS metinleri için CI testleri çalıştırın.

## Resmi Firebase referansları

- [App Check enforcement](https://firebase.google.com/docs/app-check/enable-enforcement)
- [Firestore scheduled backups](https://firebase.google.com/docs/firestore/backups)
- [Firestore point-in-time recovery](https://firebase.google.com/docs/firestore/use-pitr)
- [Firestore audit logging](https://firebase.google.com/docs/firestore/enterprise/audit-logging)
- [Firestore export/import](https://firebase.google.com/docs/firestore/manage-data/export-import)
