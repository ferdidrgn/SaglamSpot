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

## Bilinen sınırlamalar

- Belirli kullanıcı gruplarına (örn. "sadece X ürünü sepetinde olanlar")
  hedefli bildirim göndermek için bir backend/Cloud Function gerekir —
  şu an sadece "herkese" (`all_users` konusu) yayın yapılabiliyor.
- Bildirime dokunduğunda belirli bir ürün sayfasına yönlendirme şu an
  YOK — sadece uygulamayı açıyor. Bu, mesaj verisine (`data` alanı) bir
  ürün ID'si eklenerek ve `NotificationService._onNotificationTapped`
  içinde yönlendirme kodu yazılarak eklenebilir (istenirse ayrı bir
  işte yapılabilir).
- Web'de (tarayıcı) push bildirimleri için ayrıca bir Service Worker
  (`firebase-messaging-sw.js`) ve VAPID anahtarı gerekir — bu turda
  kapsam dışı bırakıldı (sadece Android/iOS native push aktif).
