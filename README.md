# 🛋️ Sağlam Spot — Spot & Sıfır Mobilya Platformu

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.38+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-3.0-blueviolet?style=for-the-badge)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)

**Responsive · Cross-Platform · Full-Stack Flutter**

[🌐 Web Demo](https://saglamspotcu.web.app) · [📱 Play Store](https://play.google.com/store/apps/details?id=com.ferdidrgn.saglamspot)

</div>

---

## 📋 İçindekiler

- [Proje Hakkında](#-proje-hakkında)
- [Özellikler](#-özellikler)
- [Mimari](#-mimari)
- [Teknoloji Yığını](#-teknoloji-yığını)
- [Güvenlik Katmanları](#-güvenlik-katmanları)
- [Kurulum](#-kurulum)
- [Ortam Değişkenleri](#-ortam-değişkenleri)
- [Firebase Yapılandırması](#-firebase-yapılandırması)
- [Proje Yapısı](#-proje-yapısı)
- [State Management](#-state-management)
- [Deeplink & SEO](#-deeplink--seo)
- [Reklam Entegrasyonu](#-reklam-entegrasyonu)
- [Deployment](#-deployment)
- [AI Agent Entegrasyonu](#-ai-agent-entegrasyonu)

---

## 🏪 Proje Hakkında

**Sağlam Spot**, İstanbul İçerenköy'de 2012'den beri hizmet veren bir mobilya dükkanının dijital
platformudur. Uygulama; hem yöneticinin ürün yönetimini yapabildiği **admin paneli** (mobil), hem de
müşterilerin ürünleri inceleyip iletişime geçebildiği **vitrin web sitesi** olarak çalışır.

Tek bir Flutter kod tabanından **Android**, **iOS** ve **Web** platformlarına aynı anda yayın
yapılabilmektedir.

---

## ✨ Özellikler

### 🌐 Web (Vitrin)

| Özellik                | Açıklama                                                        |
|------------------------|-----------------------------------------------------------------|
| **Responsive Tasarım** | Mobil, tablet ve masaüstü için optimize edilmiş ayrı layout'lar |
| **Ürün Kataloğu**      | Sıfır ve ikinci el ürün listeleme, detay sayfaları              |
| **Gelişmiş Arama**     | Kategori, durum, fiyat aralığı filtreleri                       |
| **SEO Optimizasyonu**  | Dinamik meta tag yönetimi, sitemap.xml, robots.txt              |
| **Deep Link**          | `/product/{slug}-{id}` formatında URL yapısı                    |
| **PWA Desteği**        | manifest.json, offline erişim için yapı                         |
| **Google Analytics**   | Firebase Analytics ile sayfa/etkinlik takibi                    |
| **AdSense**            | Web için display, in-article, multiplex reklam birimleri        |

### 📱 Mobil (Admin Panel)

| Özellik               | Açıklama                                                |
|-----------------------|---------------------------------------------------------|
| **Yönetici Girişi**   | Firebase Auth + Firestore admin koleksiyonu doğrulaması |
| **Ürün CRUD**         | Ekleme, düzenleme, silme ve görsel yükleme              |
| **Durum Yönetimi**    | Stokta / Satıldı toggle                                 |
| **AdMob Reklamları**  | Banner ve Native reklam birimleri                       |
| **Çevrimdışı Koruma** | Bağlantı kesintisi ekranı ile otomatik yeniden bağlanma |

### 🔍 Ortak Özellikler

- Çoklu dil desteği (**Türkçe** / **İngilizce**)
- Dinamik tema (Light / Dark Mode altyapısı)
- Firebase Remote Config ile **feature flag** yönetimi
- Firebase Crashlytics ile **otomatik hata raporlama**
- App Check ile **güvenli API erişimi**

---

## 🏗️ Mimari

Proje, **Clean Architecture** prensiplerine uygun şekilde katmanlara ayrılmıştır:

```
lib/
├── core/                    # Uygulama çekirdeği
│   ├── ads/                 # Reklam yönetimi (AdMob + AdSense)
│   ├── base/                # Base sınıflar (State, Notifier, Repo)
│   ├── config/              # Router, Initializer, Firebase Options
│   ├── errors/              # Failure sınıfları, 404 sayfası
│   ├── network/             # Connectivity provider
│   ├── services/            # Firebase, Deeplink, Remote Config
│   ├── theme/               # Renkler, tipografi, tema
│   ├── util/                # Platform checker, responsive utils
│   └── widgets/             # Paylaşılan UI bileşenleri
│
├── features/                # Özellik bazlı modüller
│   ├── auth/                # Kimlik doğrulama
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── products/            # Ürün yönetimi
│   │   ├── data/            # DataSource, Model, Repository impl
│   │   ├── domain/          # Entity, Repository interface, UseCase'ler
│   │   └── presentation/    # Pages, Providers
│   ├── search/              # Arama ve filtreleme
│   ├── home/                # Ana sayfa (Web + Mobil wrapper)
│   ├── info/                # Hakkımızda sayfası
│   └── sss/                 # SSS sayfası
│
├── shared/                  # Paylaşılan navigasyon
│   └── navigation/
│
└── l10n/                    # Lokalizasyon dosyaları
    ├── app_tr.arb
    └── app_en.arb
```

### Katman Sorumluluğu

```
Presentation → Domain → Data
     ↓              ↓        ↓
  Riverpod      UseCase   Repository
  Provider      Entity    DataSource
   Widget       Repo.     FireStore
```

---

## 🔧 Teknoloji Yığını

### Core Framework

| Teknoloji   | Versiyon | Kullanım                    |
|-------------|----------|-----------------------------|
| **Flutter** | 3.38+    | Cross-platform UI framework |
| **Dart**    | 3.5+     | Programlama dili            |

### State Management & DI

| Paket                 | Versiyon | Kullanım                     |
|-----------------------|----------|------------------------------|
| `flutter_riverpod`    | ^3.0.3   | Global state yönetimi        |
| `riverpod_annotation` | ^3.0.3   | Code generation ile provider |
| `riverpod_generator`  | ^3.0.3   | Provider kodu üretimi        |

### Firebase Servisleri

| Servis                     | Kullanım                        |
|----------------------------|---------------------------------|
| **Firebase Auth**          | E-posta/şifre + admin doğrulama |
| **Cloud Firestore**        | Ürün veritabanı                 |
| **Firebase Storage**       | Ürün görselleri                 |
| **Firebase Analytics**     | Kullanıcı davranışı takibi      |
| **Firebase Crashlytics**   | Çökme raporlama                 |
| **Firebase Remote Config** | Feature flag (adsEnabled vb.)   |
| **Firebase App Check**     | Play Integrity / DeviceCheck    |
| **Firebase Messaging**     | Push bildirim altyapısı         |

### Navigasyon & Routing

| Paket       | Kullanım                               |
|-------------|----------------------------------------|
| `go_router` | Declarative routing, deep link desteği |
| `app_links` | Native App Links / Universal Links     |

### Veri & Model

| Paket                                   | Kullanım                        |
|-----------------------------------------|---------------------------------|
| `dartz`                                 | Functional programming (Either) |
| `equatable`                             | Değer karşılaştırması           |
| `freezed` + `freezed_annotation`        | Immutable model sınıfları       |
| `json_annotation` + `json_serializable` | JSON serialization              |

### Ağ & Depolama

| Paket                    | Kullanım                            |
|--------------------------|-------------------------------------|
| `dio`                    | HTTP istemcisi                      |
| `flutter_secure_storage` | Şifreli yerel depolama (locale vb.) |
| `connectivity_plus`      | Ağ durumu izleme                    |

### UI & Medya

| Paket                  | Kullanım                  |
|------------------------|---------------------------|
| `cached_network_image` | Görselleri önbellekleme   |
| `shimmer`              | Yükleme animasyonları     |
| `image_picker`         | Galeri/kamera erişimi     |
| `file_picker`          | Dosya seçimi              |
| `pinput`               | OTP/PIN girişi            |
| `qr_flutter`           | QR kod üretimi            |
| `dynamic_color`        | Material You renk sistemi |

### Reklam

| Paket               | Kullanım                            |
|---------------------|-------------------------------------|
| `google_mobile_ads` | AdMob Banner + Native (Android/iOS) |
| AdSense (HTML)      | Web display/in-article reklamları   |

### Diğer

| Paket                 | Kullanım                       |
|-----------------------|--------------------------------|
| `url_launcher`        | Telefon, harita, tarayıcı açma |
| `share_plus`          | Ürün paylaşımı                 |
| `google_sign_in`      | Google OAuth                   |
| `permission_handler`  | İzin yönetimi                  |
| `universal_html`      | Web DOM manipülasyonu          |
| `intl`                | Tarih formatı + lokalizasyon   |
| `visibility_detector` | Scroll bazlı lazy load         |

### Geliştirme Araçları

| Araç                    | Kullanım              |
|-------------------------|-----------------------|
| `build_runner`          | Kod üretimi           |
| `flutter_lints`         | Statik analiz         |
| `flutter_native_splash` | Splash screen üretimi |

---

## 🔒 Güvenlik Katmanları

Uygulama, birden fazla güvenlik katmanıyla korunmaktadır:

### 1. Firebase App Check

```dart
// Play Integrity (Release) / Debug Token (Debug)
await
FirebaseAppCheck.instance.activate
(
androidProvider: kReleaseMode
? AndroidProvider.playIntegrity
    : AndroidProvider.debug,
appleProvider: kReleaseMode
? AppleProvider.deviceCheck
    : AppleProvider.
debug
,
);
```

### 2. Admin Doğrulama (Firestore Rules)

Mobil admin girişi yalnızca Firebase Auth başarılı olduktan **sonra**, `admins/{email}`
koleksiyonundan doğrulama yapıldığında tamamlanır. Yetkisiz kullanıcı anında `signOut()` çağrısıyla
çıkarılır.

### 3. Android Güvenlik

- **ProGuard / R8** obfuscation (release build)
- `isMinifyEnabled = true` + `isShrinkResources = true`
- `isDebuggable = false` (release)
- NDK symbol table upload (Crashlytics)
- `key.properties` ve `google-services.json` `.gitignore`'a alınmış

### 4. Güvenli Depolama

```dart
// SharedPreferences yerine şifreli depolama
final _storage = const FlutterSecureStorage();
await _storage.write(key: _prefKey, value: locale.languageCode);
```

### 5. Ağ Güvenliği

- `BaseRepository.execute()` tüm ağ çağrılarını `SocketException` ve `HttpException` için sarar
- `Either<Failure, T>` ile hata yayılımı kontrol altında

### 6. Web Güvenliği

- `assetlinks.json` ile Android App Links doğrulaması
- `apple-app-site-association` ile iOS Universal Links
- Firestore Security Rules (ayrıca yapılandırılmalı)

---

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK `>=3.38.4`
- Dart `>=3.5.4 <4.0.0`
- Firebase CLI
- Node.js (Firebase Hosting deploy için)

### Adımlar

```bash
# 1. Repo'yu klonla
git clone https://github.com/ferdidrgn/saglamspot.git
cd saglamspot

# 2. Bağımlılıkları yükle
flutter pub get

# 3. Kod üretimini çalıştır
dart run build_runner build --delete-conflicting-outputs

# 4. Lokalizasyon dosyalarını üret
flutter gen-l10n

# 5. Splash screen üret
dart run flutter_native_splash:create

# 6. Uygulamayı çalıştır
flutter run                    # Bağlı cihaz/emülatör
flutter run -d chrome          # Web
flutter run -d android         # Android
```

---

## 🔑 Ortam Değişkenleri

Aşağıdaki dosyalar **git'e dahil edilmez** ve elle oluşturulmalıdır:

| Dosya                                 | Amaç                        |
|---------------------------------------|-----------------------------|
| `android/app/google-services.json`    | Android Firebase config     |
| `ios/Runner/GoogleService-Info.plist` | iOS Firebase config         |
| `android/key.properties`              | Keystore imzalama bilgileri |
| `android/*.keystore` / `*.jks`        | İmzalama anahtarı           |

### `android/key.properties` Formatı

```properties
storePassword=<şifre>
keyPassword=<şifre>
keyAlias=<alias>
storeFile=<yol/keystore.jks>
```

---

## 🔥 Firebase Yapılandırması

### Firestore Koleksiyonları

```
firestore/
├── Product/                  # Ürünler
│   └── {productId}
│       ├── _id: String
│       ├── name: String
│       ├── desc: String
│       ├── category: String  # Enum name (sofa, chair...)
│       ├── price: Number
│       ├── imagesUrl: Array<String>
│       ├── isSold: Boolean
│       ├── isSpotProduct: Boolean
│       ├── _createdAt: String
│       ├── _updatedAt: String
│       └── _soldAt: String
│
└── admins/                   # Admin yetkili e-posta'lar
    └── {email}               # Belge ID = e-posta adresi
```

### Remote Config Parametreleri

| Key          | Type    | Default | Açıklama              |
|--------------|---------|---------|-----------------------|
| `adsEnabled` | Boolean | `true`  | Reklamları açıp kapat |

### Firebase Storage Yapısı

```
storage/
└── product_images/
    └── {productId}/
        ├── 0.jpg
        ├── 1.jpg
        └── ...
```

---

## 📁 Proje Yapısı (Detay)

### Platform Bazlı Sayfa Seçimi

Ana sayfa, platforma göre farklı widget'lar yükler:

```dart
// lib/features/home/presentation/page/wrapper/app_home_page.dart
export 'app_home_page_stub.dart'
if (dart.library.js) 'app_home_page_web.dart'
if (dart.library.io) 'app_home_page_mobil.dart';
```

### Responsive Sistem

`ResponsiveUtils` mixin'i ve `ResponsiveExtension` ile tüm boyutlar platform bağımsız yönetilir:

```dart
// Breakpoints
static const double mobileBreakpoint = 768; // < 768px
static const double tabletBreakpoint = 1024; // 768px - 1024px
static const double desktopBreakpoint = 1440; // > 1024px

// Kullanım
context.responsive
(
mobile: 16.0, tablet: 24.0, desktop: 48.0)
context.gridColumns(4) // mobil:2, tablet:3, desktop:4
context.pagePadding // platforma göre padding
```

---

## 🗂️ State Management

**Riverpod 3** ile yönetilen state katmanları:

```
┌─────────────────────────────────────────┐
│           Presentation Layer             │
│   Widget ──watches──▶ Provider           │
│   Widget ──reads───▶  Notifier.method()  │
├─────────────────────────────────────────┤
│              Domain Layer                │
│   AsyncNotifier  ──calls──▶  UseCase    │
│   UseCase        ──calls──▶  Repository │
├─────────────────────────────────────────┤
│               Data Layer                 │
│   Repository ──calls──▶  DataSource     │
│   DataSource ──calls──▶  Firestore/FB   │
└─────────────────────────────────────────┘
```

### Temel Provider'lar

| Provider                    | Tür                     | Amaç                             |
|-----------------------------|-------------------------|----------------------------------|
| `productsProvider`          | `FutureProvider`        | Tüm ürünleri Firestore'dan çeker |
| `availableProductsProvider` | `Provider`              | Satılmamış ürünler               |
| `spotDealsProductsProvider` | `Provider`              | İkinci el ürünler                |
| `searchedProductsProvider`  | `Provider`              | Filtreli arama sonuçları         |
| `authProvider`              | `NotifierProvider`      | Auth stream + login/logout       |
| `productMutationProvider`   | `AsyncNotifierProvider` | CRUD işlemleri                   |
| `connectivityProvider`      | `NotifierProvider`      | Ağ bağlantısı durumu             |
| `localeControllerProvider`  | `AsyncNotifierProvider` | Dil seçimi                       |

---

## 🔗 Deeplink & SEO

### URL Yapısı

```
https://saglamspotcu.web.app/              → Ana sayfa
https://saglamspotcu.web.app/new           → Sıfır ürünler
https://saglamspotcu.web.app/spot          → Spot ürünler
https://saglamspotcu.web.app/search        → Arama
https://saglamspotcu.web.app/product/{slug}-{id}  → Ürün detayı
```

### App Links (Android)

```xml
<!-- AndroidManifest.xml -->
<intent-filter android:autoVerify="true">
    <data android:scheme="https"
          android:host="saglamspotcu.web.app"
          android:pathPrefix="/product"/>
</intent-filter>
```

### Dinamik Meta Tag

Flutter, `web/index.html`'deki `setMeta()` JS fonksiyonunu çağırarak sayfa bazlı OG meta
etiketlerini günceller.

---

## 💰 Reklam Entegrasyonu

### Mobil (AdMob)

```
Banner Ad ID (Android):  ca-app-pub-5779807348211992/6454721883
Native Ad ID (Android):  ca-app-pub-5779807348211992/2655077678
```

### Remote Config ile Kontrol

```dart
// Reklam gösterimi tamamen Remote Config'e bağlı
ValueListenableBuilder<bool>
(
valueListenable: RemoteConfigService.adsEnabledNotifier,
builder: (context, adsEnabled, _) =>
adsEnabled ? child : const SizedBox
.
shrink
(
)
,
);
```

---

## 🚢 Deployment

### Android (Release)

```bash
flutter build appbundle --release
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### iOS

```bash
flutter build ipa --release
```

### Web (Firebase Hosting)

```bash
flutter build web --release
firebase deploy --only hosting
# Site: https://saglamspotcu.web.app
```

### CI/CD Notu

Android release build, `key.properties` ve `keystore` dosyası olmadan başarısız olur. CI ortamında
bu dosyaların güvenli şekilde sağlanması gerekir (GitHub Secrets vb.).

---

## 🤖 AI Agent Entegrasyonu

Bu proje, AI agent'larla çalışacak şekilde yapılandırılmıştır. Agent'ların bilmesi gerekenler:

### Mimari Kuralları

1. **Yeni özellik eklerken** `features/` altında `data/domain/presentation` katmanlarına uy
2. **Repository** her zaman `Either<Failure, T>` döndürmeli
3. **UseCase** tek sorumluluk prensibine uymalı
4. **Provider** oluşturulduktan sonra `dart run build_runner build` çalıştırılmalı
5. **Widget** içinde doğrudan Firestore çağrısı yapılmamalı

### Kod Üretim Komutları

```bash
# Tüm üretilmiş dosyaları yeniden oluştur
dart run build_runner build --delete-conflicting-outputs

# Lokalizasyon üret
flutter gen-l10n

# Splash screen üret
dart run flutter_native_splash:create
```

### Yeni Dil Anahtarı Ekleme

1. `lib/l10n/app_tr.arb` → Türkçe değer ekle
2. `lib/l10n/app_en.arb` → İngilizce değer ekle
3. `flutter gen-l10n` çalıştır
4. `context.l10n.yourKey` ile kullan

### Yeni Ürün Alanı Ekleme

1. `ProductModel` → `toFirestore()` + `fromFirestore()` güncelle
2. `Product` entity → alan ekle
3. `ProductMapper` → dönüşümleri güncelle
4. İlgili UI widget'larını güncelle

### Bağımlılık Eklerken

- `flutter_riverpod` ailesi birlikte tutulmalı (aynı major versiyon)
- Firebase paketleri `firebase_core` ile uyumlu olmalı
- Web'de çalışmayan paketler `kIsWeb` kontrolüyle korunmalı

---

## 📊 Proje İstatistikleri

| Metrik                | Değer                        |
|-----------------------|------------------------------|
| Desteklenen Platform  | Android, iOS, Web            |
| Mimari                | Clean Architecture           |
| State Yönetimi        | Riverpod 3                   |
| Dil Desteği           | Türkçe, İngilizce            |
| Min SDK (Android)     | Flutter default              |
| Build Tool            | Gradle 8.11.1 + Kotlin 2.3.0 |
| Firebase Paket Sayısı | 10                           |

---

## 👤 Geliştirici

**Ferdi Durgn**

- GitHub: [@ferdidrgn](https://github.com/ferdidrgn)
- Uygulama: [Play Store](https://play.google.com/store/apps/details?id=com.ferdidrgn.saglamspot)

---

<div align="center">
<sub>© 2026 Sağlam Spot Ticaret. Tüm hakları saklıdır.</sub>
</div>