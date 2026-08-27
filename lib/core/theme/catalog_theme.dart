import 'package:flutter/material.dart';

/// Sıfır Koleksiyon ve Spot/İkinci El vitrinlerinin GÖRSEL DİLİNİ merkezi
/// olarak tanımlar. İki katalog BİLİNÇLİ olarak zıt hissettirir — biri
/// sakin/butik, diğeri canlı/atölye — ama aynı yerden okunduğu için her
/// widget'ta tutarlı kalır (renkler artık dosyalara tek tek saçılmayacak).
///
/// Bu iki sayfa şu an açık/koyu temaya duyarlı DEĞİL (renkler bilerek
/// sabit) — bu dosya da aynı davranışı korur.
class NewCollectionPalette {
  NewCollectionPalette._();

  /// Sayfa/kart zemini — sıcak krem.
  static const Color background = Color(0xFFFAF8F5);
  static const Color cardBorder = Color(0xFFE8E3DC);
  static const Color heading = Color(0xFF1E1815);
  static const Color body = Color(0xFF7A6F66);

  /// CTA/vurgu — koyu, near-black kahve.
  static const Color accent = Color(0xFF2C241E);
  static const Color badgeGreen = Color(0xFF2E7D32);
  static const Color badgeGreenBg = Color(0xFFF0F7F0);
  static const Color badgeGreenBorder = Color(0xFFC8E6C9);

  static const String headingFont = 'Fraunces';

  /// Yumuşak, butik köşe yarıçapı.
  static const double cardRadius = 20;
}

class SpotPalette {
  SpotPalette._();

  /// Sayfa zemini — nötr, soğuk gri.
  static const Color background = Color(0xFFF4F5F7);
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color heading = Color(0xFF1A1A1A);
  static const Color body = Color(0xFF5A5A5A);

  /// CTA/vurgu — canlı turuncu, "fırsat" hissi.
  static const Color accent = Color(0xFFE65100);

  // NOT: Başlık fontu (Space Grotesk) bir Google Font'tur ve düz bir
  // `fontFamily` string'i olarak burada tanımlanamaz — kullanım
  // yerlerinde doğrudan `GoogleFonts.spaceGrotesk(...)` çağrılır.

  /// Daha keskin, "fiyat etiketi" hissi veren köşe yarıçapı.
  static const double cardRadius = 10;

  /// Etiket deliği motifinin yarıçapı (bkz. SpotTagCardShape).
  static const double tagHoleRadius = 5;
}
