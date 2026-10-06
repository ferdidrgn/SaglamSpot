---
name: flutter-motion
description: Animation rules for SaglamSpot's Flutter UI — decide whether something should animate, then pick the right Flutter tool, curve, duration and reduced-motion behaviour. Use when adding, reviewing or fixing any animation (implicit animations, AnimationController, Hero, page transitions, tickers/marquees, scroll reveals). Flutter adaptation of the emilkowalski/skills animation set (animate, improve-animations, review-animations, find-animation-opportunities) listed in skills-lock.json.
---

# Flutter Motion

> **SaglamSpot projesi:** Süre/eğri değerleri için `AppMotion` (`lib/core/theme/app_tokens.dart`) kullanılır — aşağıdaki tablolar o token'ların gerekçesidir.

Kaynak felsefe: Emil Kowalski'nin animasyon skill'leri (`skills-lock.json`),
CSS/Motion yerine Flutter API'leriyle yeniden yazıldı.

## 1. Animasyon olmalı mı?

| Sıklık | Karar |
| --- | --- |
| Günde 100+ (klavye kısayolu, sekme değiştirme) | Animasyon yok |
| Günde onlarca (hover, liste gezinme, alt nav) | Neredeyse fark edilmez: ≤150ms, küçük |
| Ara sıra (sheet, dialog, snackbar, segment) | Standart animasyon |
| Nadir / ilk kez (onboarding, başarı) | "Keyif bütçesi" burada |

Amacını tek kelimeyle adlandıramıyorsan (geri bildirim, mekânsal süreklilik,
durum değişimi, sert geçişi yumuşatma, açıklama, keyif) yapma.

## 2. En ucuz araç

1. `AnimatedContainer`, `AnimatedOpacity`, `AnimatedScale`, `AnimatedSlide`,
   `AnimatedSwitcher`, `TweenAnimationBuilder` — durum değişimi.
2. `AnimationController` + `*Transition` widget'ları (`FadeTransition`,
   `SlideTransition`, `ScaleTransition`) — tekrar eden/kontrollü hareket.
   **`AnimatedBuilder` + `Opacity` yerine `FadeTransition`** kullan: her
   karede rebuild yerine yalnızca layer özelliği değişir.
3. `Hero` — ürün kartı → detay mekânsal süreklilik (tag: `prod_img_<id>`).
4. Fizik/yay (`SpringSimulation`, `animateWith`) — sürükle-bırak, fırlatma.

Yeni animasyon paketi ekleme; SDK yeterli.

## 3. Özellikler

- Yalnızca **transform + opacity** hareket ettir (`Transform`, `*Transition`,
  `AnimatedScale/Slide/Opacity`). `width/height/padding` animasyonu layout
  tetikler; kaçınılmazsa (segment dolgusu gibi küçük tek öğe) sorun değil,
  ama liste/ızgara içinde yapma.
- **Asla scale 0'dan başlama**: 0.94–0.97 + opacity 0.
- Popover/menü `alignment`/`transformAlignment` tetikleyicinin olduğu köşe;
  dialog merkezde kalır.

## 4. Eğri ve süre (proje tokenları)

| Durum | Eğri |
| --- | --- |
| Giriş/çıkış | `Curves.easeOutCubic` (güçlü ease-out: `Cubic(0.23, 1, 0.32, 1)`) |
| Ekranda yer değiştirme | `Curves.easeInOutCubic` |
| Sabit hareket (marquee, progress) | `Curves.linear` |

**Arayüzde asla `Curves.easeIn`.** Süreler: basma geri bildirimi 100–160ms,
küçük popover 125–200ms, menü 150–250ms, sheet/dialog 200–400ms. UI
animasyonu gerekçesiz 300ms'yi geçmez. Liste/ızgara girişinde 30–60ms
kademelendirme (stagger), toplam ≤ 400ms.

## 5. Kesinti ve çıkış

- Hızlı tetiklenen şeylerde (toggle, segment, favori kalbi) implicit
  animasyon kullan — mevcut değerden yeniden hedeflenir.
- Girdiği yoldan çıkar.

## 6. Azaltılmış hareket + hover

```dart
final reduce = MediaQuery.disableAnimationsOf(context);
final offset = reduce ? Offset.zero : const Offset(0, 0.04);
```

- Azaltılmış hareket = daha az ve daha yumuşak, sıfır değil: opacity kalsın,
  kayma/ölçek gitsin.
- Hover efektleri yalnız fare olan yerde (`MouseRegion` zaten dokunmada
  tetiklenmez); dokunmatikte basma geri bildirimi `TactilePress`
  (`core/widgets/design_system/tactile_press.dart`).

## 7. Sürekli hareket (ticker, shimmer, spotlight) — performans kuralları

Düşük segment Android'lerde yavaşlığın bir numaralı nedeni sonsuz
animasyonlardır.
- Ekranda değilken **dur**: `VisibilityDetector` (paket zaten var) ya da
  `TickerMode`. Kaydırılıp görünmez olan bir marquee kare üretmeye devam
  etmemeli.
- Kare başına sabit piksel (`_offset += 0.6`) değil **geçen süreyle** ilerle;
  aksi halde 120Hz ekranda iki kat hızlı akar.
- Her karede `saveLayer` açan `ShaderMask`/`Opacity`/`BackdropFilter`
  içeren alt ağacı `RepaintBoundary` ile izole et.
- `MediaQuery.disableAnimationsOf` true ise sürekli hareketi hiç başlatma.

## İnceleme listesi (her PR)

| Asla | Yerine |
| --- | --- |
| `Curves.easeIn` UI'da | `easeOutCubic` |
| scale 0 girişi | 0.95 + opacity 0 |
| Gerekçesiz >300ms | 150–250ms |
| Her bölümde fade-up | tek orkestre an (web'de ticker + sayaç; ızgarada en fazla 6 adımlı stagger) |
| Görünmezken çalışan `repeat()` | VisibilityDetector ile duraklat |
| `AnimatedBuilder` → `Opacity` | `FadeTransition` |
| reduced-motion yok | `disableAnimationsOf` dalı |
| Aynı anda giren her şey | 30–60ms stagger |
