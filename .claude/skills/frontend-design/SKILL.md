---
name: frontend-design
description: Distinctive, intentional visual design for Flutter UI (web + mobile) in SaglamSpot. Use when building a new screen/section or reshaping an existing one — aesthetic direction, typography, layout width and responsiveness, and choices that don't read as templated defaults. Adapted from claude-code-templates creative-design/frontend-design (Apache-2.0, see LICENSE.txt) from CSS/HTML to Flutter.
license: Complete terms in LICENSE.txt
---

# Frontend Design — Flutter uyarlaması

> **SaglamSpot projesi:** Önce `.claude/skills/saglamspot-design/SKILL.md` (Atölye konsepti, token'lar, hazır `Atelier*` bileşenleri) ve `.claude/skills/saglamspot-ui/SKILL.md` (dokunulmazlar) okunur; aşağıdaki genel kurallar onların Flutter karşılıklarıyla uygulanır.

Kaynak: `npx claude-code-templates@latest --skill creative-design/frontend-design`
(`davila7/claude-code-templates` → `creative-design/frontend-design`,
Ekim 2026 metniyle karşılaştırıldı). Orijinal CSS/HTML dilinde yazılmıştı;
aşağıdaki her kural Flutter karşılığıyla yeniden yazıldı. Projeye özel
koruma kuralları için önce `.claude/skills/saglamspot-ui/SKILL.md` dosyasını oku.

Upstream'in "boşluk = lüks" varsayılanı bu vitrine uymaz. Jakobsen /
NORÉA gibi atölye siteleri parçaya nefes verir; Sağlam Spot'un işi
raftaki parçayı çabuk göstermektir. Flutter'da bunu şöyle uygula:
bant zemini tam genişlik, ürün ızgarası 1640'a kadar, okuma metni
`maxWidth: 680`. Hareket: tek orkestre an (`flutter-motion`); her
bölüme fade-up ekleme. Bilet köşesini her karta kopyalama.

Bir tasarım stüdyosunun tasarım lideri gibi çalış: her müşteriye kimsenin
başkasıyla karıştırmayacağı bir görsel kimlik veren, şablon hissi veren
önerileri reddetmiş bir müşteri için. Palet, tipografi ve yerleşim kararları
bu brife özel olsun.

## Konu: ikinci el + sıfır mobilya, İstanbul'da gerçek bir dükkan

SaglamSpot'un malzemesi ahşap, kumaş, cila, depo, kamyonet, usta eli.
Görsel kararların kaynağı bu dünya: sıcak ahşap kahveleri, adaçayı yeşili
("Sıfır"), bakır/kiremit ("İkinci El"), gerçek ürün fotoğrafları. Stok
fotoğrafı yerine dükkanın kendi ürün görselleri her zaman daha güçlü.

## Tasarım ilkeleri

- **Hero**: konunun en karakteristik şeyiyle açıl — burada gerçek ürünler
  ve dükkanın kendisi. "Büyük sayı + küçük etiket + gradyan" varsayılan
  kalıptır; gerçekten en iyisi değilse kullanma.
- **Tipografi kişiliği taşır**: en fazla iki aile. Projede başlık = Fraunces
  (serif, `AppTextStyles.headingFontFamily`), gövde = Inter
  (`AppTextStyles.fontFamily`). Yeni aile ekleme; `'Fraunces'` gibi string
  literal yerine `AppTextStyles.*` kullan (google_fonts aileyi
  `Fraunces_600` gibi isimlerle kaydeder, çıplak literal sessizce varsayılan
  fonta düşebilir).
- **Satır uzunluğu** < 80 karakter: gövde metnini
  `ConstrainedBox(constraints: BoxConstraints(maxWidth: 680))` ile sınırla.
  Serif gövdeye `height: 1.6`, sans gövdeye `1.5` ver.
- **Kaçınılacak tipografik klişeler**: başlıkta tek kelimeyi farklı renk/italik
  yapmak; her etikete ALL CAPS; her başlığın üstüne gereksiz "eyebrow" etiket.
- **Görsel yapı bilgidir**: çerçeve, numara (01/02/03), ayraç yalnızca içerik
  gerçekten bir sıra/süreçse (ör. "Nasıl Çalışır" adımları) kullanılır.
- **Kullanıcı tetiklemediği hareket az ve bilinçli**: tek bir orkestre giriş
  anı, her bölümde fade+slide değil. Kullanıcı eylemine cevap veren hareket
  (açma, genişletme, onay) serbest. Ayrıntı: `flutter-motion` skill'i.

## Genişlik ve responsive (Flutter)

- Breakpoint'ler `ResponsiveUtils`'te: mobil < 768, tablet < 1024, desktop
  ≥ 1024, geniş ≥ 1440. Yeni sabit icat etme.
- **Tüm sayfayı tek bir max-width kutusuna sokma.** Bölüm ZEMİNLERİ (renk
  bantları, koyu footer, görsel hero) ekranın tam genişliğine yayılır;
  yalnızca İÇERİK ortalanıp sınırlanır (`Center` + `ConstrainedBox(maxWidth:
  1280)` + yatay padding). Aksi halde 1920px ekranda iki yanda ölü şerit
  kalır.
- Yatay kenar boşluğu genişlikle ölçeklenir: mobil 16, tablet 32, desktop
  48–64.
- Izgaralarda sütun sayısını genişlikten türet (`SliverGridDelegateWithMaxCrossAxisExtent`
  ya da `context.gridColumns()`); sabit `crossAxisCount: 4` telefon/geniş
  ekranda bozulur.
- Bir widget'ın kararını ekran değil **kendi alanı** belirliyorsa
  `LayoutBuilder` kullan (ör. yan yana → alt alta geçen kart ikilisi).
- Her şeyi 360px (küçük Android), 768px, 1280px ve 1920px'de kontrol et.
  Yatay taşma (overflow şeridi) sıfır olmalı.

## Süreç: planla, brife karşı gözden geçir, kur, eleştir

Güncel AI tasarımlarının kümelendiği varsayılanlar (brif açıkça istemedikçe
serbest eksenini bunlara harcama):
1. krem zemin + yüksek kontrast serif + kiremit/terracotta aksan (#D97757
   civarı) — SaglamSpot'un markası zaten sıcak kahve/krem; bu yüzden
   **ayrışmayı yerleşim ve fotoğraf kullanımında** ara, rengi daha da
   "AI kremi"ne itme;
2. neredeyse siyah zemin + tek asit yeşili aksan;
3. gazete tarzı kılçık çizgiler, sıfır radius, yoğun sütunlar;
4. SaaS kart kiti: her şey aynı radius'lu, aynı `Colors.black.withOpacity(.1)`
   gölgeli özdeş kartlar, dekor olarak gradyan yıkamalar;
5. konu ne olursa olsun görünen şablon süsleri: her başlığın üstünde
   harf aralıklı BÜYÜK HARF etiket, `A · B · C` meta dizileri, buton
   metinlerine eklenen `→`.

İki geçişte çalış:
- **Plan**: 4–6 isimli hex (mevcut `AppColors` tokenlarından seç), tipografi
  rolleri, ASCII tel kafes ile yerleşim + hizalama (sol/orta), sayfayı özgün
  kılan 2–3 ilke.
- **Gözden geçir**: herhangi bir parça "benzer her sayfaya yapacağım
  varsayılan" gibi okunuyorsa değiştir, neyi neden değiştirdiğini söyle.
  Sonra kodla.

Flutter'a özgü kod hijyeni:
- Renk/yarıçap/gölge için `AppColors`, `AppGlassTokens` (`context.glass`),
  `catalog_theme.dart` paletleri — paralel token sistemi kurma.
- İç içe `Padding` + `margin` + `SizedBox` boşlukları birbirini ikiye
  katlamasın; bölüm arası dikey ritmi tek bir yerde (bölüm sarmalayıcısı)
  tanımla.

## Ölçülülük ve öz eleştiri

Cesaretini tek bir yerde harca: bir öğe akılda kalsın, çevresi sakin olsun.
Kalite tabanı sessizce sağlanır: 360px'e kadar responsive, klavye odağı
görünür (web), `MediaQuery.disableAnimationsOf(context)` saygısı, kontrast,
dokunma hedefi ≥ 48dp. Mümkünse ekran görüntüsü alarak eleştir
(`flutter build web` + Playwright/Chromium bu ortamda çalışır).
Chanel'in tavsiyesi: çıkmadan önce aynaya bak ve bir aksesuarı çıkar.

## Metin

Metin tasarım içeriğidir. Kullanıcının dilinde, etken çatıyla, kısa yaz.
CTA ne olacağını söyler ("WhatsApp'tan sor", "Ürünü gör"); aynı eylem akış
boyunca aynı adı taşır. Hata ve boş durum yön gösterir: ne oldu, nasıl
düzelir. Tüm metinler `context.l10n` üzerinden (ARB), koda gömülü Türkçe
metin ekleme.
