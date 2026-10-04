---
name: saglamspot-ui
description: Project guardrails for any UI or performance change in SaglamSpot (Flutter, web + Android/iOS). Read FIRST before touching screens, widgets, theme, images or animations — lists the screens that must not change, the design tokens to reuse, and the performance rules that keep the app fast on low-end Android phones.
---

# SaglamSpot UI + performans kuralları

Bu skill diğer skill'lerin (`frontend-design`, `mobile-design`,
`flutter-motion`, `flutter-interactive-ui`) projeye uygulanmış halidir. Çelişki olursa **bu dosya
kazanır**.

## 1. Dokunulmaz ekranlar

- **Keşfet (`lib/features/products/presentation/pages/discover_page.dart`)**
  — solda döndürülmüş metinli dikey kategori rayı
  (`CategoryAccentRail(orientation: Axis.vertical)`), üstte Sıfır/İkinci El
  segmenti, sağda `ResponsiveProductGrid`. Kullanıcı bu ekranı özellikle
  seviyor: yerleşimi, rayı, segmenti, kart görünümünü DEĞİŞTİRME.
  Performans düzeltmeleri görünümü birebir koruyorsa serbest. Zemin
  (`AtelierBackground`, kullanıcının seçtiği doku) eklenebilir — "Düz"
  seçilince eski görünümün aynısıdır.
- **Kart tasarımları**: `CustomProductCard`, ana sayfadaki
  `_ProductListRow`, favori satırı/kartı, sepet kartı, admin ürün ızgarası
  kartı. Kullanıcı "kart tasarımı hariç her şeyi yenile" dedi — kartlara
  dokunma, çevrelerini (zemin, başlık, filtre, boş durum) yenile.
- **Ürün kartı (`core/widgets/custom_product_card.dart`)** — asimetrik
  köşeler (sol üst/sağ alt 8, sağ üst/sol alt 34), sağ üstte köşeye oturan
  SIFIR/İKİNCİ EL etiketi, alt scrim üstünde ad + kategori + fiyat hapı.
  Görünüm aynı kalmalı.
- `claude/youthful-maxwell-pus0xt` branch'inde gelen özellikler main'e
  alındı; bir değişiklik bunlardan birini kaldırıyorsa dur ve sor.

## 2. Token'lar (yeni sistem kurma)

Ayrıntılı tasarım sistemi: `.claude/skills/saglamspot-design/SKILL.md`
(`AppSpacing`/`AppRadius`/`AppMotion`/`AppShadows` + `Atelier*`
bileşenleri).


- Renk: `AppColors.*` (getter, tema/dinamik renge duyarlı), mobil yüzeyler
  için `AppColors.mobile*`; kategori/koşul renkleri `catalog_theme.dart`.
- Cam/yarıçap/gölge: `context.glass` (`AppGlassTokens`).
- Tipografi: `AppTextStyles` — Fraunces başlık, Inter gövde.
- Breakpoint/ızgara: `ResponsiveUtils` + `context.gridColumns()`,
  `context.responsive(...)`.
- Metin: `context.l10n` (11 dil) — koda gömülü metin yok.

## 3. Web yerleşimi

- Zemin bantları tam genişlik, içerik `ContentWidth` (maks 1280) ile
  ortalanır — tüm `CustomScrollView`'u tek bir max-width kutusuna sarma.
- 360 / 768 / 1280 / 1920 px'de yatay taşma olmamalı.
- Ana sayfada bölüm sayısını artırma; yeni bölüm eklemek yerine mevcut
  birini güçlendir (bkz. `frontend-design` → "cesaretini tek yerde harca").

## 4. Performans (düşük segment Android öncelikli)

1. **Görsel decode boyutu**: ağ görselleri her zaman ekrandaki boyutta
   decode edilir. `OptimizedCachedImage` genişlik/yükseklik verilmediğinde
   `LayoutBuilder` ile kendi alanını ölçer — `Image.network` ya da çıplak
   `CachedNetworkImage` kullanma; kullanıyorsan `cacheWidth` /
   `memCacheWidth` ver. 12 MP telefon fotoğrafı tam çözünürlükte ~48 MB RAM.
2. **BackdropFilter**: kaydırılan içeriğin üstünde (alt nav, yüzen
   butonlar, liste içi kartlar) blur her karede yeniden hesaplanır.
   `AppPerformance.allowBackdropBlur` false iken (Android native) opak
   tint'e düş. Cam görünüm için `GlassSurface` kullan — kendi
   `BackdropFilter`'ını yazma.
3. **Sonsuz animasyonlar** (`repeat()`): görünmezken dur (VisibilityDetector),
   süreye göre ilerle, `RepaintBoundary` ile izole et, reduced-motion'da
   başlatma. Bkz. `flutter-motion` §7.
4. **Liste/ızgara**: `ListView.builder`/`SliverGrid` — `shrinkWrap: true`
   + `Column` içinde uzun liste yok. Ağır kart içinde `MediaQuery.of`
   yerine `MediaQuery.sizeOf`/`devicePixelRatioOf` (yalnız ilgili değişince
   rebuild).
5. **Açılış**: `main()` içinde `runApp` öncesi yalnızca ilk karenin
   kararına gereken şeyler `await` edilir; birbirinden bağımsız
   SharedPreferences yüklemeleri `Future.wait` ile paralel.
6. Riverpod: build içinde `ref.watch(x.select(...))` ile yalnız gereken
   alanı dinle; türetilmiş liste provider'larını her build'de yeniden
   filtreleme.

## 5. Doğrulama

- `flutter analyze` — yeni error/warning yok.
- Web görsel kontrol: `flutter build web` + Playwright/Chromium
  (`/opt/pw-browsers`), 1440 ve 390 genişlikte ekran görüntüsü.
- Mobil performans: `flutter run --profile` + DevTools "raster" çubuğu;
  jank varsa önce görsel decode ve blur'a bak.
