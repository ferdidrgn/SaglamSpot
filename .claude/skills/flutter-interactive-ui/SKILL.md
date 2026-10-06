---
name: flutter-interactive-ui
description: Interactive UI, user operations and plugin (package) rules for SaglamSpot's Flutter app. Use when adding or changing anything the user DOES — taps, long-press menus, swipe actions, pull-to-refresh, bottom sheets, filters, search, favorites, share/WhatsApp/directions, gallery zoom, admin forms (add/edit/delete/mark sold, photo pick & reorder) — or when considering a new pub.dev package/plugin. Covers gesture→widget mapping, feedback (haptics, SnackBar + undo), action states, forms, accessibility and performance of interactions.
---

# Etkileşimli UI, işlemler ve eklentiler

> **SaglamSpot projesi:** Görsel dil için `saglamspot-design`, koruma
> kuralları için `saglamspot-ui`, süre/eğri için `flutter-motion`
> (`AppMotion`). Bu skill "kullanıcı ne YAPAR ve arayüz nasıl CEVAP
> VERİR" sorusunu kapsar. Yeni hareket eklerken her bölüme ayrı
> fade-up koyma; basma cevabı `TactilePress` + `AppMotion.fast` yeter.
> Doluluk uğruna dokunma hedefini 48dp altına indirme.

Temel kural: **her eylemin görünür bir cevabı, hatanın bir çıkış yolu ve
geri alınabilir işlemin bir "Geri al"ı vardır.** Cevapsız dokunuş,
açıklamasız hata, onaysız kalıcı silme yok.

## 1. İşlem haritası — kim neyi yapar

| Akış | Kullanıcı işlemi | Arayüz deseni |
|---|---|---|
| Vitrin (Ana sayfa, Keşfet, Arama) | gez, kategori seç, Sıfır/İkinci El seç, ara, sırala | `CategoryAccentRail` (dikey), segment / `AtelierChoiceChip`, `AtelierSearchField` |
| Ürün | fotoğraflarda gezin, yakınlaştır, favorile, paylaş, WhatsApp'tan sor, yol tarifi | `PageView` + nokta göstergesi, `InteractiveViewer`, kalp toggle, `share_plus`, `url_launcher` |
| Favoriler / Sepet (istek listesi) | kaydırıp kaldır, adet değiştir, tek mesajla sor | `Dismissible` + Geri al SnackBar, stepper, alt sabit CTA |
| Ayarlar | tema, doku, dil, bildirim izni | segment, önizlemeli seçim, `app_settings` |
| Admin | ürün ekle/düzenle/sil, satıldı/rezerve işaretle, fotoğraf seç/sırala, filtrele | form bölümleri, `image_picker`, onay diyaloğu, toggle + optimistic UI |

Yeni bir ekran/özellik eklerken önce bu tabloya satır ekle: işlem →
desen → geri bildirim → hata durumu.

## 2. Jest → widget eşlemesi

| Jest | Ne zaman | Flutter / proje widget'ı | Not |
|---|---|---|---|
| Dokun | her birincil eylem | `TactilePress` (yay geri dönüşlü küçülme), `InkWell` | hedef ≥ 48dp |
| Uzun bas | ikincil hızlı eylemler (paylaş, favori, admin: düzenle/sil) | `onLongPress` → `showModalBottomSheet` eylem listesi | uzun basma tek yol OLMASIN; aynı eylem görünür bir butonda da olsun |
| Sola kaydır | listeden kaldır (favori, sepet) | `Dismissible(direction: endToStart)` | arka planda kırmızı + ikon; kaldırınca **Geri al** SnackBar |
| Aşağı çek | listeyi yenile | `RefreshIndicator(color: AppColors.accent)` | `ref.invalidate(...)` ve `.future`'ı bekle |
| Yatay kaydır | fotoğraf, öne çıkanlar, çipler | `PageView` / yatay `ListView` | sayfa göstergesi + erişilebilir ok butonu |
| Çimdikle / çift dokun | fotoğraf yakınlaştırma | `InteractiveViewer` (galeri `decodeScale: 3.0`) | çift dokunmada 1x↔2.5x |
| Sürükle | filtre paneli, admin fotoğraf sırası | `DraggableScrollableSheet`, `ReorderableListView` | tutamaç (grabber) göster |

## 3. Geri bildirim merdiveni

| Olay | Görsel | Dokunsal (`HapticFeedback`) | Metin |
|---|---|---|---|
| Seçim değişti (çip, segment, ray) | dolgu/renk geçişi (`AppMotion.fast`) | `selectionClick` | — |
| Toggle (favori, satıldı) | ikon ölçek + renk (`AnimatedSwitcher`, scale 0.8→1) | `lightImpact` | gerekirse kısa SnackBar |
| Kalıcı/yıkıcı onay (sil, sepeti boşalt) | onay diyaloğu, kırmızı birincil buton | `mediumImpact` | ne silineceğini adıyla söyle |
| Başarı (ürün kaydedildi) | buton → ✓ durumu, sonra geri git | `lightImpact` | "Kaydedildi" — eylemle aynı fiil |
| Hata | satır içi hata + `AppErrorNotifier` | — | ne oldu + ne yapılır + Tekrar dene |

- `heavyImpact` kullanılmaz. Haptik web'de yoktur — kodda `kIsWeb` kontrolü
  gerekmez (no-op), ama haptik **tek** geri bildirim olmamalı.
- **Geri alınabilir > onay diyaloğu.** Favoriden/sepetten kaldırma geri
  alınabilir → diyalog yok, `SnackBar(action: SnackBarAction(label: Geri al))`.
  Ürün silme geri alınamaz → onay diyaloğu.

Uygulama karşılıkları:

- Geri al bildirimi: `lib/core/widgets/action_feedback.dart`
  (`showUndoSnackBar`, `removeFavoriteWithUndo`, `removeCartItemWithUndo`,
  `confirmDiscardChanges`).
- WhatsApp açılmazsa arama önerisi: `SaglamSpotCommunication.launchWhatsApp`.
- Arama: `SearchPage._onSearchChanged` 300 ms.
- Admin ekle/düzenle: alan terk edince hata, gönderimde ilk hatalı alana
  kaydırma, fotoğraf sırası (`ReorderableListView`), kayıtsız çıkış
  (`PopScope`).

```dart
void _removeWithUndo(final BuildContext context, final WidgetRef ref, final Product p) {
  HapticFeedback.mediumImpact();
  ref.read(favoritesProvider.notifier).toggle(p);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(context.l10n.removedFromFavorites),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: context.l10n.undo,
        onPressed: () => ref.read(favoritesProvider.notifier).toggle(p),
      ),
    ));
}
```

## 4. Eylem durumları — her buton/işlem için

`idle → pressed → loading → success | error`, ayrıca `disabled`.

- **loading:** buton genişliği sabit kalır, metnin yerine küçük
  `CircularProgressIndicator(strokeWidth: 2)`; ikinci dokunuş YOK SAYILIR
  (çift kayıt/çift silme olmaz).
- **optimistic UI:** favori, satıldı/rezerve toggle'ı hemen değişir; sunucu
  hatasında eski değere döner + hata bildirimi.
- **success:** kısa (≤ 800ms) ✓ durumu; sayfa kapanacaksa önce geri
  bildirim, sonra `Navigator.pop`.
- **error:** neden + çözüm + "Tekrar dene" (`AtelierStateView` ya da satır
  içi). "Bir hata oluştu" ile bitirme.
- Uzun işlemler (fotoğraf yükleme) ilerleme yüzdesi gösterir; iptal
  edilebiliyorsa iptal butonu.

## 5. Arama, filtre, sıralama

- Arama yazarken sonuçları **300ms debounce** ile güncelle; her tuşta
  liste yeniden hesaplanmasın.
- Aktif filtreler üstte kaldırılabilir çip olarak görünür; "Filtreleri
  temizle" her zaman bir dokunuş uzakta.
- Filtre paneli `showModalBottomSheet(isScrollControlled: true,
  showDragHandle: true)`; uygulanana kadar ana liste değişmez, alt sabit
  "Uygula (N ürün)" butonu sonuç sayısını canlı gösterir.
- Kategori seçimi tüm uygulamada aynı: dikey `CategoryAccentRail`.
- Boş sonuç: `AtelierStateView` + "Filtreleri temizle" eylemi.

## 6. Admin formları

- Alanlar `AdminFormSection` + `AdminFormField`; klavye türü doğru
  (fiyat → `numberWithOptions(decimal: true)`), `textInputAction: next`
  ile alanlar arası geçiş, son alanda `done`.
- Doğrulama alan terk edilince (`onFocusChange`) satır içi; gönderimde
  ilk hatalı alana kaydır + odakla.
- Kaydetme butonu form geçerli değilken pasif değil — basınca hataları
  gösterir (kullanıcı neyin eksik olduğunu görsün).
- Fotoğraf: `image_picker` ile çoklu seçim, küçük önizleme, uzun basıp
  sürükleyerek sıralama, köşedeki ✕ ile kaldırma (Geri al'lı).
- Kaydedilmemiş değişiklikle geri çıkışta `PopScope` ile "Değişiklikler
  kaydedilmedi" uyarısı.
- Silme / "satıldı" gibi kalıcı durumlar ürünün adını içeren onay ister.

## 7. Dış eylemler (paylaş, WhatsApp, ara, yol tarifi)

- Hepsi tek yerden: `SaglamSpotCommunication` (`core/util/comminucation_actions.dart`)
  ve `FurnitureShareService`. Ekranda yeni `launchUrl` yazma.
- WhatsApp mesajı ürün adı + fiyat + bağlantı ile ön doldurulur.
- Uygulama açılamazsa (WhatsApp yok) sessiz kalma: telefonla arama
  alternatifini öner.

## 8. Eklentiler (paketler)

Önce mevcut olana bak — projede hazır:

| İhtiyaç | Paket (pubspec'te var) |
|---|---|
| Paylaşım | `share_plus` |
| WhatsApp / telefon / harita / mağaza | `url_launcher` |
| Fotoğraf seçme | `image_picker` |
| Görsel önbellek | `cached_network_image` (→ `OptimizedCachedImage`) |
| İskelet yükleme | `shimmer` (→ `shimmer_components.dart`) |
| Görünürlük (lazy, animasyon durdurma) | `visibility_detector` (→ `PauseWhenOffscreen`) |
| Sistem ayarları (bildirim izni) | `app_settings` |
| Yerel bildirim / derin bağlantı | `flutter_local_notifications`, `app_links` |

Yeni paket eklemeden önce sırayla sor:
1. Flutter SDK yapabiliyor mu? (`Dismissible`, `RefreshIndicator`,
   `DraggableScrollableSheet`, `ReorderableListView`, `InteractiveViewer`,
   `AnimatedList`, `SearchAnchor`, implicit animasyonlar → paket gerekmez.)
2. Projede aynı işi yapan paket var mı?
3. Paket: null-safe, son 12 ayda güncellenmiş, pub puanı yüksek, Android +
   iOS + **web** destekli mi (web'de kırılmamalı)? APK boyutuna etkisi?
4. Eklersen: `pubspec.yaml`'a sürüm kısıtıyla, nedenini bir satır yorumla;
   `flutter pub get` + `flutter analyze`; web'de desteklenmiyorsa koşullu
   import (`*_stub.dart` / `*_web.dart` deseni, bkz. `google_maps_embed`).

Animasyon paketi (`flutter_animate`, `lottie`, `rive`) ekleme — SDK
yeterli. Durum yönetimi tek: Riverpod.

## 9. Erişilebilirlik ve performans

- İkon-only butonlara `tooltip` + `Semantics(label:)`; seçili öğelere
  `Semantics(selected: true)`; özel jestlerin (kaydır, uzun bas) görünür
  bir buton karşılığı olsun.
- Hareket azaltma açıksa (`MediaQuery.disableAnimationsOf`) ölçek/kayma
  yok, yalnız renk/opaklık.
- Toggle bir satırı değiştiriyorsa yalnız o satır yeniden çizilsin:
  `ref.watch(provider.select((s) => s.contains(id)))`.
- Liste öğesinde `GlobalKey` yok; `Dismissible`/`Reorderable` için
  `ValueKey(product.id)`.

## Kontrol listesi (her etkileşimli özellik)

- [ ] İşlem haritasına satırı eklendi (işlem → desen → geri bildirim → hata).
- [ ] Görsel + (uygunsa) haptik geri bildirim var.
- [ ] loading sırasında çift tetikleme engellendi.
- [ ] Geri alınabilir işlemde Geri al; kalıcı işlemde onay.
- [ ] Hata durumunda neden + çözüm + Tekrar dene.
- [ ] Jestin görünür buton karşılığı var; Semantics etiketli; ≥ 48dp.
- [ ] Yeni metinler 11 ARB'ye eklendi.
- [ ] Yeni paket eklendiyse §8 soruları cevaplandı, web'de test edildi.
