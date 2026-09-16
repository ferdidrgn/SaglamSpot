# GitHub Actions — CI/CD Kurulumu

Bu klasördeki workflow'lar `main` dalına yapılan her push'ta web/Android build+deploy'unu,
her PR/push'ta da hızlı bir analiz+test kontrolünü otomatikleştirir. Deploy workflow'ları
gerçek secret'lar eklenene kadar **çalışmaz** (401/403/dosya bulunamadı gibi hatalar verir) —
bu beklenen bir durumdur.

Secret'ları eklemek için: **GitHub reposu > Settings > Secrets and variables > Actions >
New repository secret**.

## Workflow'lar

| Dosya | Tetikleyici | Ne yapar |
|---|---|---|
| `deploy-web.yml` | push → `main` | `flutter build web --release` + Firebase Hosting'e deploy |
| `deploy-android.yml` | push → `main` | İmzalı `flutter build appbundle --release` + Play Console'a yükleme (`internal` track) |
| `deploy-ios.yml` | push → `main` | `flutter build ipa --no-codesign` ile SADECE derleme doğrulaması (imzalama/yükleme YOK — bkz. dosya içindeki not) |
| `distribute-android-beta.yml` | push → `develop` veya manuel (`workflow_dispatch`) | İmzasız `flutter build apk --debug` + Firebase App Distribution ile test grubuna dağıtım |
| `ci-checks.yml` | her PR + her dala push | `flutter analyze` + `flutter test` (hızlı geri bildirim, secret gerektirmez) |

## Gerekli GitHub Secrets listesi

### Web deploy (`deploy-web.yml`)

- **`FIREBASE_SERVICE_ACCOUNT`**
  Firebase Console > Project Settings (⚙️) > Service Accounts sekmesi >
  "Generate new private key" ile indirilen JSON dosyasının **tüm içeriği**.
  Proje: `saglamspotflutter-2a1a8`, hosting site: `saglamspotcu`.

  `GITHUB_TOKEN` otomatik sağlanır, ayrıca eklemenize gerek yok.

### Android deploy (`deploy-android.yml`)

- **`ANDROID_KEYSTORE_BASE64`**
  Upload/release keystore dosyanızın (`.jks`) base64 hâli:
  `base64 -i upload-keystore.jks | tr -d '\n'` çıktısını secret'a yapıştırın.
- **`KEYSTORE_PASSWORD`** — keystore oluştururken belirlediğiniz store şifresi.
- **`KEY_ALIAS`** — keystore içindeki anahtarın alias'ı.
- **`KEY_PASSWORD`** — anahtarın (key) şifresi.
- **`GOOGLE_SERVICES_JSON`**
  Firebase Console > Project Settings > "Your apps" > Android uygulaması
  (`com.ferdidrgn.saglamspot`) > `google-services.json` dosyasının **tüm içeriği**.
  Bu dosya repoda `.gitignore` ile hariç tutulmuştur ve `com.google.gms.google-services`
  Gradle eklentisi olmadan build BAŞARISIZ olur — bu yüzden bu secret ZORUNLUDUR
  (görev tanımında açıkça istenmemiş olsa da, Android build'in çalışması için şarttır).
- **`PLAY_STORE_SERVICE_ACCOUNT_JSON`**
  Play Console > Setup > API access > "Choose a service account" akışıyla oluşturulan
  Google Cloud servis hesabının indirilen JSON anahtarının tüm içeriği. Bu hesaba Play
  Console tarafında ilgili uygulama için en az "Release to production, alpha and beta
  tracks" izni verilmelidir.

  **Önemli:** Yükleme `track: internal` olarak ayarlıdır — otomasyon doğrudan production'a
  yayın YAPMAZ. Yükleme sonrası Play Console > Internal testing ekranından inceleyip
  isterseniz elle bir üst track'e (alpha/beta/production) terfi ettirin.

### iOS (`deploy-ios.yml`)

Şu an için **hiçbir secret gerekmiyor** — workflow yalnızca `flutter build ipa --no-codesign`
ile derlemenin kırılmadığını doğrular, imzalama veya TestFlight/App Store yüklemesi yapmaz.

İmzalama ve TestFlight/App Store dağıtımını otomatikleştirmek isterseniz bunu bu repodan
bağımsız olarak, kendi Apple Developer ortamınızda **Xcode Cloud** ya da **Fastlane match**
ile kurmanız gerekir (geçerli bir Apple Developer hesabı, dağıtım sertifikaları ve
provisioning profile'lar gerektirir). Fastlane match yolunu seçerseniz ek olarak şu
secret'lar gerekecektir: `MATCH_GIT_URL`, `MATCH_PASSWORD`,
`APP_STORE_CONNECT_API_KEY` (veya `APPLE_ID` + uygulamaya özel şifre), `ASC_KEY_ID`,
`ASC_ISSUER_ID`.

### Android beta dağıtımı (`distribute-android-beta.yml`)

- **`GOOGLE_SERVICES_JSON`** — `deploy-android.yml` ile AYNI secret/değer (yukarıya bakın).
- **`FIREBASE_APP_ID`**
  Firebase Console > Project Settings > General > "Your apps" > Android
  uygulaması > "App ID" (google-services.json içindeki `mobilesdk_app_id`
  ile aynı değer).
- **`FIREBASE_APP_DISTRIBUTION_SERVICE_ACCOUNT`**
  Google Cloud Console > IAM & Admin > Service Accounts ile oluşturulan,
  "Firebase App Distribution Admin" rolüne sahip bir servis hesabının
  indirilen JSON anahtarının tüm içeriği.

  **Not:** Bu workflow İMZASIZ bir debug APK dağıtır (test/QA amaçlı) —
  `ANDROID_KEYSTORE_BASE64` gibi release imzalama secret'larına ihtiyaç
  duymaz. Ayrıca Firebase Console > App Distribution > Testers &
  Groups altında `testers` adında bir grup oluşturup test edecek
  kişilerin e-postalarını eklemeniz gerekir (workflow bu grup adına
  dağıtır).

### CI checks (`ci-checks.yml`)

Secret gerektirmez.

## Özet — eklenmesi gereken secret'lar

```
FIREBASE_SERVICE_ACCOUNT
ANDROID_KEYSTORE_BASE64
KEYSTORE_PASSWORD
KEY_ALIAS
KEY_PASSWORD
GOOGLE_SERVICES_JSON
PLAY_STORE_SERVICE_ACCOUNT_JSON
FIREBASE_APP_ID
FIREBASE_APP_DISTRIBUTION_SERVICE_ACCOUNT
```
