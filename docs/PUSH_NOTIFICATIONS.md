# Push Bildirimleri (Firebase Cloud Messaging) — Kurulum ve Kullanım

Bu doküman, uygulamaya eklenen push + uygulama içi bildirim sisteminin
ne yaptığını, kodda neyin hazır olduğunu ve **sizin Firebase Console /
Apple Developer tarafında yapmanız gereken adımları** anlatır. Bu
ortamda (sandbox) Firebase Console'a veya Apple Developer Portal'a
erişimim yok — bu adımları sizin tamamlamanız gerekiyor.

## Mimari özeti

Bu proje ayrı bir bildirim gönderme sunucusu (backend) veya Cloud
Function **içermiyor**. Bunun yerine:

1. Her cihaz açılışta otomatik olarak `all_users` adlı bir **FCM
   konusuna (topic)** abone olur (bkz. `NotificationService.init()`).
2. Siz (mağaza sahibi) Firebase Console'daki **Messaging** panelinden
   hiç kod yazmadan bu konuya (`all_users`) hedefli bir kampanya/anlık
   mesaj gönderirsiniz.
3. Uygulama bu mesajı yakalar:
   - Uygulama **kapalı/arka planda** iken: Android/iOS bunu otomatik
     sistem bildirimi olarak gösterir (ekstra kod gerekmez).
   - Uygulama **açık (foreground)** iken: `flutter_local_notifications`
     ile elle bir sistem bildirimi gösteriyoruz (aksi halde foreground
     mesajlar sessizce kaybolur — FCM'in bilinen bir davranışı).
   - Her iki durumda da mesaj, cihazda kalıcı bir **bildirim gelen
     kutusuna** kaydedilir (`NotificationInboxCache`, SharedPreferences
     tabanlı) ve uygulama içindeki **🔔 zil ikonundan** (ana sayfa
     başlığı) erişilebilir; okunmamış sayısı kırmızı rozetle gösterilir.

## Kodda hazır olanlar

- `lib/core/services/notification_service.dart` — izin isteme, konuya
  abone olma, foreground/background/tıklama olaylarını dinleme.
- `lib/core/services/notification_inbox_cache.dart` — cihazda kalıcı
  bildirim geçmişi.
- `lib/core/providers/notification_inbox_provider.dart` — Riverpod
  katmanı (okunmamış sayaç, listeleme, okundu işaretleme).
- `lib/features/notifications/presentation/pages/notifications_page.dart`
  — bildirim listesi ekranı (`/notifications` rotası).
- Ana sayfa başlığındaki 🔔 ikonu (okunmamış rozetiyle).
- `android/app/src/main/AndroidManifest.xml`: `POST_NOTIFICATIONS`
  izni (Android 13+ zorunlu) + varsayılan bildirim kanalı/ikon/renk.
- `ios/Runner/Info.plist`: `UIBackgroundModes: remote-notification`.

## Sizin Firebase Console'da yapmanız gerekenler

### 1. Cloud Messaging API'nin aktif olduğunu doğrulayın
Firebase projeniz (`saglamspotflutter-2a1a8`) muhtemelen bunu otomatik
aktif etmiştir. Doğrulamak için: [Firebase Console](https://console.firebase.google.com)
→ projenizi seçin → **Project settings** → **Cloud Messaging** sekmesi
→ "Cloud Messaging API (V1)" **Enabled** yazmalı.

### 2. Android — `google-services.json`
Bu dosya bilinçli olarak Git'e eklenmemiş (`.gitignore`'da). Zaten
yerel makinenizde mevcut olmalı (aksi halde uygulama hiç derlenmezdi).
Eğer kayıpsa: Firebase Console → Project settings → sayfanın altındaki
Android uygulaması → **google-services.json indir** → `android/app/`
klasörüne koyun.

### 3. iOS — APNs (Apple Push Notification service) anahtarı **[YAPMANIZ ŞART]**
Bu adımı ben yapamam — Apple Developer hesabınıza ve Xcode'a erişim
gerektiriyor:

1. [Apple Developer Portal](https://developer.apple.com/account) →
   **Certificates, Identifiers & Profiles** → **Keys** → yeni bir
   **APNs Auth Key** oluşturun (Apple Push Notifications service (APNs)
   kutusunu işaretleyin), `.p8` dosyasını indirin (**sadece bir kez
   indirilebilir**, güvenli saklayın), Key ID'yi not edin.
2. Firebase Console → Project settings → **Cloud Messaging** sekmesi →
   **Apple app configuration** → **Upload** → `.p8` dosyasını, Key ID'yi
   ve Team ID'nizi girin.
3. Xcode'da `ios/Runner.xcworkspace`'i açın → Runner hedefi →
   **Signing & Capabilities** → **+ Capability** → **Push
   Notifications** ekleyin (Background Modes → Remote notifications
   zaten Info.plist üzerinden ayarlı, ama Xcode'da capability olarak da
   görünmesi gerekebilir).

Bu adım atlanırsa: Android'de bildirimler çalışır, **iOS'ta çalışmaz**
(sessizce başarısız olur, hata vermez).

### 4. Bir bildirim/kampanya nasıl gönderilir (kod yazmadan)
1. Firebase Console → **Engage** → **Messaging** → **New campaign** →
   **Notifications**.
2. Başlık + metin girin.
3. **Target** adımında: "Topic" seçin, konu adı olarak tam olarak
   `all_users` yazın (uygulamanın abone olduğu konu budur).
4. Gönder / zamanla.

Test için önce kendi cihazınızda uygulamayı açıp konsoldaki debug
loglarından (`📲 FCM cihaz token: ...`) token'ı alıp "Send test message"
ile tek cihaza da gönderebilirsiniz.

## Otomatik bildirimler (Cloud Functions) — artık kod tarafında hazır

Yukarıdaki "elle kampanya gönder" akışının yanına, `functions/index.js`
içinde iki OTOMATİK bildirim eklendi. Bunlar `firebase deploy --only
functions` ile deploy edildikten sonra kendiliğinden çalışır, Console'da
hiçbir şey yapmanız gerekmez:

### 1. Günlük "yeni ürün" özeti (`dailyProductDigest`)
Her ürün eklendiğinde ayrı ayrı bildirim GÖNDERMEZ (gece yarısı ya da
art arda çok ürün eklenirse kullanıcıyı rahatsız eder, bildirimleri
kapatmasına yol açar). Bunun yerine her gün **saat 11:00'de (İstanbul
saati)** bir kez çalışır, son özetten bu yana kaç yeni ürün eklendiğine
bakar; varsa TEK bir özet bildirimi gönderir ("3 yeni ürün eklendi"),
yoksa hiçbir şey göndermez. `all_users` konusuna yayınlanır (herkese).

Saati değiştirmek isterseniz: `functions/index.js` içinde
`dailyProductDigest`'in `schedule: "0 11 * * *"` satırındaki cron
ifadesini düzenleyip yeniden deploy edin.

### 2. Fiyat düşüşü bildirimi (`notifyPriceDrop`)
Bir ürünün fiyatı gerçekten düşünce, SADECE o ürünü favorileyen
cihazlara anında, kişiye özel bir bildirim gönderir ("Favorin ucuzladı!
🎉"). Bu, günlük özetten farklı olarak spam riski taşımaz — kişi
bilerek favorilediği bir ürün için, nadir gerçekleşen bir olayda
bildirim alır.

Bunun çalışabilmesi için Flutter tarafı, cihazın favorilediği ürün
ID'lerini `notification_subscriptions/{fcmToken}` Firestore
dokümanına yazar (bkz. `lib/core/services/favorite_notification_sync.dart`,
`FavoritesNotifier` her favori ekleme/çıkarmada tetikler).

### ⚠️ Firestore güvenlik kuralı eklemeniz GEREKİYOR

Bu projede Firestore kuralları repo'da değil, Firebase Console'da
tutuluyor — bu yüzden aşağıdaki kuralı **siz** Console → Firestore
Database → Rules sekmesinden eklemelisiniz (aksi halde müşteri
cihazları `notification_subscriptions`'a yazamaz, favori senkronu
sessizce başarısız olur):

```
match /notification_subscriptions/{token} {
  allow read: if false; // sadece Cloud Functions (Admin SDK) okur, kurallardan muaf
  allow write: if request.resource.data.keys().hasOnly(['productIds', 'updatedAt'])
               && request.resource.data.productIds is list;
}
```

## Bilinen sınırlamalar

- Belirli kullanıcı gruplarına hedefli bildirim artık MÜMKÜN (yukarıdaki
  `notifyPriceDrop` — favorileyenlere özel) ama genel yayın hâlâ sadece
  "herkese" (`all_users` konusu) ya da "favorileyenlere" şeklinde; daha
  ince segmentasyon (örn. "sadece belirli bir semtte oturanlar") için ek
  geliştirme gerekir.
- Bildirime dokunduğunda belirli bir ürün sayfasına yönlendirme şu an
  YOK — sadece uygulamayı açıyor. Bu, mesaj verisine (`data` alanı) bir
  ürün ID'si eklenerek ve `NotificationService._onNotificationTapped`
  içinde yönlendirme kodu yazılarak eklenebilir (istenirse ayrı bir
  işte yapılabilir). Yeni fonksiyonlar zaten `data.productId`
  gönderiyor, sadece istemci tarafında okuyup yönlendirme eklenmesi
  yeterli.
- `notifyPriceDrop` gece de anında gönderilir (günlük özetteki gibi
  "sabaha ertele" mantığı yok) — kişiye özel/nadir bir olay olduğu için
  bilinçli olarak böyle bırakıldı, istenirse aynı erteleme mantığı buna
  da eklenebilir.
- Web'de (tarayıcı) push bildirimleri için ayrıca bir Service Worker
  (`firebase-messaging-sw.js`) ve VAPID anahtarı gerekir — bu turda
  kapsam dışı bırakıldı (sadece Android/iOS native push aktif).
