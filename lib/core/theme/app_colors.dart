import 'package:flutter/material.dart';

/// "Soft Premium" palet — köklü renk değişimi. Tüm sabit isimler
/// (primary, secondary, accent, background, surface...) AYNI kaldı;
/// sadece DEĞERLER değişti. Bu sayede bu isimlere bağlı 30'dan fazla
/// dosya (ColorScheme, tema, kartlar, butonlar) hiçbir kod değişikliği
/// gerektirmeden yeni paleti otomatik olarak alır.
///
/// Önceki palet: Zümrüt/Orman Yeşili + Altın vurgu.
/// Yeni palet: Sıcak toprak tonu bej/krem + kömür siyahı + tek amber/
/// terracotta vurgu (ikinci_sans_furniture prototipinden entegre edildi).
class AppColors {
  // --- ANA LÜKS PALET (Sıcak Krem & Kömür Temelli) ---
  static const Color primary = Color(0xFF2E2A26); // kömür siyahı (ink)
  static const Color primaryVariant = Color(0xFF201C18); // daha koyu kömür
  static const Color onPrimary = Color(0xFFC98A4B); // amber/terracotta vurgu

  static const Color surface = Color(0xFFFFFDF9); // sıcak fildişi
  static const Color onSurface = Color(0xFF4A443D); // yumuşak kömür metin
  static const Color background = Color(0xFFFAF6F0); // sıcak krem zemin

  static const Color secondary = Color(0xFFF3EDE3); // sıcak bej panel
  static const Color onSecondary = Color(0xFF4A443D); // panel üstü metin/ikon
  static const Color secondaryVariant = Color(0xFFE6DDCF); // hafif koyu bej

  // --- YARDIMCI VE SEMANTİK RENKLER ---
  static const Color white = Colors.white;
  static const Color black = Color(0xFF201C18); // tam siyah yerine kömür
  static const Color error = Color(0xFFC0392B); // sıcak, güven veren kırmızı
  static const Color onError = Color(0xFFE07A6B);
  static const Color success = Color(0xFF6E8B5B); // zeytin yeşili başarı
  static const Color warning = Color(0xFFD98C3D);
  static const Color info = Color(0xFF5B7C99);

  // --- METİN VE SINIRLAR ---
  static const Color textPrimary = Color(0xFF2E2A26); // ana başlıklar
  static const Color textSecondary = Color(0xFF6B5D50); // açıklama metinleri
  static const Color textTertiary = Color(0xFF8A8177); // yardımcı/hint metin
  static const Color textLight = white;

  static const Color border = Color(0xFFE6DDCF); // sıcak, ince sınırlar
  static const Color divider = Color(0xFFEFE8DB); // çok hafif sıcak ayraçlar

  // --- GRİ TONLAMALARI (Neutral — sıcak tona kaydırıldı) ---
  static const Color lightGrey = Color(0xFFF3EDE3);
  static const Color mediumGrey = Color(0xFFD8CDBC);
  static const Color darkGrey = Color(0xFF4A443D);

  // --- ARKA PLANLAR ---
  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF1C1512); // koyu mod (pasif)

  // --- MODERN PRIMARY (artık indigo değil — kömür tonuyla uyumlu) ---
  static const Color primaryDark = Color(0xFF1C1512);
  static const Color primaryLight = Color(0xFF6B5D50);

  // --- SECONDARY (artık pembe değil — sıcak terracotta) ---
  static const Color secondaryDark = Color(0xFFAD6B37);
  static const Color secondaryLight = Color(0xFFE7C6A0);

  // --- ACCENT (Amber/Terracotta — markanın tek sıcak vurgusu) ---
  static const Color accent = Color(0xFFC98A4B);
  static const Color accentDark = Color(0xFFAD6B37);
  static const Color accentLight = Color(0xFFE7C6A0);

  // --- NEUTRAL UI ---
  static const Color card = Color(0xFFFFFDF9);

  // --- DARK MODE PALETİ (uygulama ThemeMode.light'a sabitli, pasif) ---
  static const Color darkBackground = Color(0xFF1C1512);
  static const Color darkSurface = Color(0xFF2A231E);
  static const Color darkCard = Color(0xFF332B24);
  static const Color darkTextPrimary = Color(0xFFF3EDE3);
  static const Color darkTextSecondary = Color(0xFFB8AC9C);
  static const Color darkBorder = Color(0xFF443A31);

  // --- GRADIENT YAPILARI ---
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF352F29), primary], // kömür geçişi
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryVariant], // sıcak bej geçişi
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark], // amber/terracotta geçişi
  );

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, secondary], // kremden sıcak beje
  );
}
