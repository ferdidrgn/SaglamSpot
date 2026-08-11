import 'package:flutter/material.dart';

class AppColors {
  // --- ANA PALET (Sıcak Ekru & Espresso Temelli) ---
  static const Color primary = Color(0xFF3E2F23); // koyu espresso kahve (ana metin/koyu zemin)
  static const Color primaryVariant = Color(0xFF2A1F17); // daha koyu espresso
  static const Color onPrimary = Color(0xFFA9714B); // sıcak ceviz/tarçın vurgu

  static const Color surface = Color(0xFFFFFDF9); // kırık beyaz kart zemini
  static const Color onSurface = Color(0xFF3E2F23); // espresso metin
  static const Color background = Color(0xFFF5EFE6); // sıcak ekru/krem zemin

  static const Color secondary = Color(0xFFEDE3D3); // açık ahşap bej ikincil zemin
  static const Color onSecondary = Color(0xFF3E2F23); // panel üstü metin/ikon
  static const Color secondaryVariant = Color(0xFFE0D3BC); // koyu ahşap bej

  // --- YARDIMCI VE SEMANTİK RENKLER ---
  static const Color white = Colors.white;
  static const Color black = Color(0xFF2A1F17); // tam siyah yerine espresso
  static const Color error = Color(0xFFB4543A); // sıcak, toprak tonu kırmızı
  static const Color onError = Color(0xFFE0917A);
  static const Color success = Color(0xFF7C8B6F); // yumuşak adaçayı yeşili
  static const Color warning = Color(0xFFC98A4B);
  static const Color info = Color(0xFF6E7D8F);

  // --- İKİNCİ AKSAN (Adaçayı Yeşili — organik his) ---
  static const Color sage = Color(0xFF7C8B6F);
  static const Color sageDark = Color(0xFF62705A);
  static const Color sageLight = Color(0xFFA3AE97);

  // --- METİN VE SINIRLAR ---
  static const Color textPrimary = Color(0xFF3E2F23); // ana başlıklar
  static const Color textSecondary = Color(0xFF6B5744); // açıklama metinleri
  static const Color textTertiary = Color(0xFF8F7D6B); // yardımcı/hint metin
  static const Color textLight = white;

  static const Color border = Color(0xFFE0D3BC); // sıcak, ince sınırlar
  static const Color divider = Color(0xFFEDE3D3); // hafif sıcak ayraçlar

  // --- GRİ TONLAMALARI (Neutral — sıcak ahşap tona kaydırıldı) ---
  static const Color lightGrey = Color(0xFFEDE3D3);
  static const Color mediumGrey = Color(0xFFCFC0A8);
  static const Color darkGrey = Color(0xFF6B5744);

  // --- ARKA PLANLAR ---
  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF241A13); // koyu espresso zemin (footer, istatistik)

  // --- MODERN PRIMARY (espresso tonuyla uyumlu) ---
  static const Color primaryDark = Color(0xFF241A13);
  static const Color primaryLight = Color(0xFF6B5744);

  // --- SECONDARY (sıcak ceviz/tarçın) ---
  static const Color secondaryDark = Color(0xFF8B5A3A);
  static const Color secondaryLight = Color(0xFFC79868);

  // --- ACCENT (Ceviz/Tarçın — markanın sıcak vurgusu) ---
  static const Color accent = Color(0xFFA9714B);
  static const Color accentDark = Color(0xFF8B5A3A);
  static const Color accentLight = Color(0xFFC79868);
  // --- NEUTRAL UI ---
  static const Color card = Color(0xFFFFFDF9);

  // --- DARK MODE PALETİ (uygulama ThemeMode.light'a sabitli, pasif) ---
  static const Color darkBackground = Color(0xFF241A13);
  static const Color darkSurface = Color(0xFF32251C);
  static const Color darkCard = Color(0xFF3D2D22);
  static const Color darkTextPrimary = Color(0xFFEDE3D3);
  static const Color darkTextSecondary = Color(0xFFC2B29B);
  static const Color darkBorder = Color(0xFF4A3A2C);

  // --- GRADIENT YAPILARI ---
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A3A2C), primary], // espresso geçişi
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryVariant], // ahşap bej geçişi
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark], // ceviz/tarçın geçişi
  );

  static const Gradient sageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sage, sageDark], // adaçayı geçişi
  );

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, secondary], // ekruden ahşap beje
  );

  // ================================================================
  // MOBİL UYGULAMA PALETİ — Web'in sıcak espresso/ekru kimliğinden
  // bilinçli olarak ayrışan, yönetici panelinin kendine has rengi.
  // Koyu petrol yeşili + canlı zümrüt vurgu.
  // ================================================================
  static const Color mobilePrimary = Color(0xFF0F3D3E); // koyu petrol yeşili
  static const Color mobilePrimaryDark = Color(0xFF0A2A2B);
  static const Color mobilePrimaryLight = Color(0xFF1D5D5E);

  static const Color mobileAccent = Color(0xFF1FA97D); // canlı zümrüt vurgu
  static const Color mobileAccentDark = Color(0xFF158462);
  static const Color mobileAccentLight = Color(0xFF5FD1A6);

  static const Color mobileBackground = Color(0xFFF2F7F5); // soğuk mint-gri zemin
  static const Color mobileSurface = white;
  static const Color mobileCardBg = white;
  static const Color mobileSecondaryBg = Color(0xFFE4EEEA); // yumuşak mint ikincil zemin

  static const Color mobileTextPrimary = Color(0xFF0D2624);
  static const Color mobileTextSecondary = Color(0xFF4C6663);
  static const Color mobileTextTertiary = Color(0xFF7E9491);
  static const Color mobileBorder = Color(0xFFD7E5E1);

  static const Gradient mobileAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mobileAccent, mobileAccentDark],
  );

  static const Gradient mobilePrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mobilePrimaryLight, mobilePrimary],
  );
}
