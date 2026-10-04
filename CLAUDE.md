# SaglamSpot — proje hafızası

Flutter (Android / iOS / web) mobilya vitrini — İçerenköy'deki gerçek bir
dükkânın sıfır ve ikinci el (spot) ürünleri. Satın alma yok: vitrin +
WhatsApp + yol tarifi. Bu dosya her oturumun başında okunur; subagent
başlatırken buradaki kuralları prompt'a özetle.

## Önce oku (UI / tasarım / animasyon / performans işi)

1. `.claude/skills/saglamspot-ui/SKILL.md` — dokunulmaz ekranlar,
   performans kuralları. **Önce bu.**
2. `.claude/skills/saglamspot-design/SKILL.md` — "Atölye" tasarım sistemi:
   konsept, token'lar, hazır bileşenler, arka plan dokuları, kontrol
   noktası.
3. `.claude/skills/frontend-design/SKILL.md` — görsel yön (Flutter
   uyarlaması).
4. `.claude/skills/mobile-design/` — dokunma, platform, mobil performans.
5. `.claude/skills/flutter-motion/SKILL.md` — animasyon kuralları.
6. `.claude/skills/flutter-interactive-ui/SKILL.md` — etkileşimli UI,
   kullanıcı işlemleri (jestler, geri bildirim, Geri al, eylem durumları,
   admin formları) ve yeni paket/eklenti politikası.

## Tasarım sistemi — "Atölye"

- Token'lar: `lib/core/theme/app_tokens.dart` → `AppSpacing`, `AppRadius`
  (imza asimetrik köşe `asymSm`/`asymLg`), `AppMotion`, `AppShadows`.
  Yeni/değiştirilen her widget'ta ham sayı yerine bunlar.
- Bileşenler: `lib/core/widgets/design_system/atelier_*.dart` —
  `AtelierBackground`, `AtelierScreenHeader`, `AtelierSectionHeader`,
  `AtelierSearchField`, `AtelierIconButton`, `AtelierChoiceChip`,
  `AtelierPanel`, `AtelierStateView`.
- Kategori seçimi her yerde aynı: `CategoryAccentRail` dikey ray (Keşfet,
  Arama, Admin).
- Arka plan dokusu kullanıcı tercihi (`backgroundPatternProvider`).

## SABİT KURALLAR

- **Keşfet ekranının yerleşimi ve ürün kartı tasarımları değişmez.**
- **Marka renkleri değişmez** — `AppColors` hex'leri sabit; erişim her
  zaman getter'larla. Yeni hex icat etme.
- Tüm metin `context.l10n` — yeni anahtar 11 ARB dosyasının hepsine
  (`lib/l10n/app_*.arb`, şablon `app_tr.arb`), sonra `flutter gen-l10n`.
- Ağ görselleri `OptimizedCachedImage` ile (ekran boyutunda decode).
- Android'de `BackdropFilter` yok → `AdaptiveBackdropBlur`/`GlassSurface`.
- Sürekli animasyon ekrandan çıkınca durur → `PauseWhenOffscreen`.
- Yeni paket eklemeden önce `pubspec.yaml`'daki mevcut paketlere bak
  (karar listesi: `flutter-interactive-ui` §8).
- Her eylemin görünür cevabı var; geri alınabilir işlemde "Geri al",
  kalıcı işlemde onay; loading sırasında çift tetikleme yok.

## Mimari notlar

- Riverpod 3 (`flutter_riverpod: ^3.0.3`). `@riverpod` codegen var; yeni
  codegen provider eklersen `dart run build_runner build` gerekir — yoksa
  klasik `Provider`/`NotifierProvider` kullan (ör. `backgroundPatternProvider`).
- `AsyncValue.valueOrNull` yok → `.value`.
- Firebase başlatılamazsa (zaman aşımı) uygulama donmamalı: Firebase
  `.instance` erişimlerini `Firebase.apps.isNotEmpty` ile koru (router ve
  auth provider bu şekilde).
- Web ve mobil ayrı sayfa dosyaları (`*_web.dart` / `*_mobile*.dart`);
  "mobili büyütüp web diye sunma".
- Reklam: AdSense `web/index.html` head'inde (ca-pub-5779807348211992);
  birimler `core/ads/ads_manager.dart`. Uygulama AMP değil — `amp-auto-ads`
  EKLENMEZ (bkz. index.html'deki not: içeriksiz ekranda reklam ihlali).

## Kontrol

- `flutter analyze` — yeni error/warning yok (analysis_options'taki iki
  `removed_lint` uyarısı ve `product_filters_provider.dart`'taki
  `allProducts` önceden var).
- `flutter test` — `test/widget_test.dart`'taki "güvensiz cihaz" testi
  önceden kırık.
- Web görsel kontrol: `flutter build web` + Playwright (`/opt/pw-browsers`).
