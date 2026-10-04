---
name: saglamspot-design
description: SaglamSpot's own design system — "Atölye" (the furniture workshop). Use before creating or restyling ANY mobile screen, component, admin page, background, search UI or animation in this repo. Lists the concept, tokens (AppSpacing/AppRadius/AppMotion/AppShadows), the ready-made Atelier components, background textures and the per-screen checklist. Adapts frontend-design + mobile-design + flutter-motion to this codebase.
---

# SaglamSpot "Atölye" tasarım sistemi

Flutter (Android + iOS + web). Bu dosya genel skill'leri (`frontend-design`,
`mobile-design`, `flutter-motion`) bu projeye çevirir; koruma kuralları
için `saglamspot-ui`. Çelişkide sıra: `saglamspot-ui` > bu dosya > genel
skill'ler.

## Konu, kitle, iş

- **Konu:** İstanbul İçerenköy'de gerçek bir mobilya dükkânı — sıfır ve
  ikinci el (spot) mobilya. Satın alma akışı yok; vitrin + WhatsApp.
- **Kitle:** Türkiye'de, çoğu orta/düşük segment Android telefonla gelen,
  pratik ve fiyat odaklı müşteri; 11 dil.
- **Ana iş:** Uygulamayı aç → beğendiğin parçayı bul → esnafa sor / dükkâna
  gel. Motto: *"Gelmeden gör, beğenince gel."*
- **Görsel dağarcık:** ahşap damarı, mezura/cetvel çentikleri, keten
  kumaş, cila parlaklığı, vitrine düşen öğleden sonra ışığı, usta işi
  kenarlar. Asla "SaaS dashboard", asla jenerik e-ticaret şablonu.

## Konsept zinciri

Dükkân kapısı (ana sayfa) → vitrin (Keşfet / Arama) → parçanın yakın
planı (ürün detayı) → esnafla konuşma (WhatsApp) → dükkâna yol tarifi.
Her ekran bu zincirde bir halka; tasarım kararı bu halkaya hizmet
etmiyorsa çıkar.

## Token'lar — `lib/core/theme/app_tokens.dart`

| Token | Kullanım |
|---|---|
| `AppSpacing.xxs…huge`, `screen` (16), `section` (28) | ham `EdgeInsets`/`SizedBox` sayısı yerine |
| `AppRadius.xs…xl`, `pill`, `asymSm`, `asymLg` | `asym*` = imza köşe (ürün kartıyla aynı dil) — ekran başına 1-2 vurgu |
| `AppMotion.fast/normal/slow`, `standard` (güçlü ease-out), `move`, `stagger` | ham `Duration`/`Curves` yerine |
| `AppShadows.level0…level4(tint)` | tek katman gölge; aynı öğeye üst üste gölge yok |

Renk: daima `AppColors.*` getter'ları (tema + Material You'ya duyarlı).
Yeni hex icat etme. Tipografi: `AppTextStyles.serif(...)` (Fraunces) başlık,
gövde Inter (tema varsayılanı). `fontFamily: 'Fraunces'` literal YAZMA.

## Hazır bileşenler — `lib/core/widgets/design_system/`

| Bileşen | Ne zaman |
|---|---|
| `AtelierBackground` | Her mobil ekranın `body`'si. Kullanıcının seçtiği dokuyu çizer (statik, RepaintBoundary). |
| `AtelierScreenHeader` | Ekran başlığı: serif başlık + `TapeMeasureRule` imzası + `leading`/`actions`. AppBar yerine. |
| `AtelierSectionHeader` | Ekran içi bölüm başlığı (ALL-CAPS eyebrow YOK). |
| `AtelierSearchField` | Tüm arama alanları. `controller` yoksa "dokun → aramaya git" kipi. |
| `AtelierIconButton` | 48×48 ikon butonu, rozet desteği, tooltip+Semantics dahili. |
| `AtelierChoiceChip` | Sıralama/durum gibi yatay seçimler. |
| `AtelierPanel` | Gruplanmış yüzey (ayar listesi, admin kartı). `signature: true` = asimetrik köşe. |
| `AtelierStateView` | Boş/hata durumu: ikon + ne oldu + ne yapılır + eylem. Çıplak "Hata" metni yok. |
| `CategoryAccentRail(orientation: Axis.vertical)` | Kategori seçimi: Keşfet, Arama, Admin panelinde AYNI dikey ray. |

## Etkileşim ve işlemler

Kullanıcının yaptığı her şey (dokun, uzun bas, kaydır, yenile, filtrele,
favorile, paylaş, admin formları) ve yeni paket kararları için
`.claude/skills/flutter-interactive-ui/SKILL.md`: jest → widget eşlemesi,
geri bildirim merdiveni (haptik + Geri al), eylem durumları, eklenti
politikası.

## Arka plan dokuları — `background_pattern_provider.dart`

`BackgroundPattern.plain | wood | tape | linen`, Ayarlar > Görünüm'den
seçilir, `SharedPreferences`'ta saklanır, `main()`'de `runApp` öncesi
yüklenir. Desen opaklığı ≤ 0.09; içerikle yarışmaz. Yeni desen eklersen:
enum + `AtelierPatternPainter` dalı + 11 ARB'de `bgPattern*` anahtarı.

## Her ekranda 7 katman

structure · typography · color · depth · motion · interaction · content
hierarchy. Her eleman bir amaca hizmet etmeli — sırf güzel göründüğü için
efekt yok.

- **Cesaret tek yerde:** ekran başına bir imza öğesi (Ayarlar'da asimetrik
  profil paneli, Ana sayfada story hero, Keşfet'te dikey ray).
- **Derinlik:** gölge yerine çoğu yerde ince kenarlık + zemin farkı;
  `level3+` yalnız yüzen/öne çıkan öğede.
- **Cam/blur:** ana dil değil; yalnız overlay/yüzen kontrol. Android'de
  `AdaptiveBackdropBlur` zaten kapatır.
- **Hareket:** yalnız yönlendirme/geri bildirim/süreklilik/keyif için;
  `AppMotion` süreleri; reduced-motion'a saygı (bkz. `flutter-motion`).
- **Dokunma:** hedefler ≥ 48dp, aralarında ≥ 8dp; birincil eylem başparmak
  bölgesinde (alt yarı).
- **Erişilebilirlik:** ikon-only butona `tooltip`/`Semantics(label:)`;
  seçili durum `Semantics(selected:)`; kontrast AA.
- **Metin:** tümü `context.l10n` (11 ARB). Yeni anahtar → 11 dilin hepsine
  ekle, `flutter gen-l10n`.

## Kaçın (üretilmiş UI işaretleri)

her yerde gradyan, her kartta gölge + kenarlık + glow birlikte, ALL-CAPS
etiketler, başlıkta tek kelimeyi renklendirme, her bölümde fade-up, aynı
radius'lu özdeş kart yığını, emoji ikonlar, `CircularProgressIndicator`
dışında hiçbir şey olmayan yükleme ekranı.

## Dokunulmazlar (özet — ayrıntı `saglamspot-ui`)

- Keşfet ekranının **yerleşimi** (dikey ray + segment + ızgara). Zemin
  dokusu eklenebilir; düzen değişmez.
- Ürün kartları (`CustomProductCard`, ana sayfadaki `_ProductListRow`,
  favori satırı, sepet kartı) — kart tasarımına dokunma.

## Yazmadan önce kontrol noktası

Söyle: hangi ekran, hangi platform(lar), tek imza öğesi ne, hangi
token/bileşenleri kullanıyorsun, yükleme/hata/boş durumları, 360dp ve
tablet genişliğinde davranış. Bitince sor: *"Bu ekran gerçekten bir
mobilya dükkânına mı ait, yoksa herhangi bir Flutter şablonu mu?"*
