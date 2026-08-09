import 'package:flutter/material.dart';

/// "Sıcak & Doğal" palet — köklü renk değişimi. Tüm sabit isimler
/// (primary, secondary, accent, background, surface...) AYNI kaldı;
/// sadece DEĞERLER değişti. Bu sayede bu isimlere bağlı 30'dan fazla
/// dosya (ColorScheme, tema, kartlar, butonlar) hiçbir kod değişikliği
/// gerektirmeden yeni paleti otomatik olarak alır.
///
/// Önceki palet: Sıcak krem + kömür siyahı + amber/terracotta vurgu.
/// Yeni palet: Ahşap tonları, ekru, organik — sıcak ceviz/tarçın vurgusu
/// ve yumuşak adaçayı yeşili ikinci aksanla desteklenmiş, doğal bir his.
class AppColors {
  // --- ANA DOĞAL PALET (Sıcak Ekru & Espresso Temelli) ---
  static const Color primary = Color(0xFF3E2F23); // koyu espresso kahve (ana metin)
  static const Color primaryVariant = Color(0xFF2A2018); // daha koyu espresso
  static const Color onPrimary = Color(0xFFFFFDF9); // espresso üzeri kırık beyaz metin

  static const Color surface = Color(0xFFFFFDF9); // kart arka planı (kırık beyaz)
  static const Color onSurface = Color(0xFF3E2F23); // espresso metin
  static const Color background = Color(0xFFF5EFE6); // sıcak ekru/krem zemin

  static const Color secondary = Color(0xFFEDE3D3); // açık ahşap bej (ikincil zemin)
  static const Color onSecondary = Color(0xFF3E2F23); // panel üstü metin/ikon
  static const Color secondaryVariant = Color(0xFFE0D2B8); // hafif koyu ahşap bej

  // --- YARDIMCI VE SEMANTİK RENKLER ---
  static const Color white = Colors.white;
  static const Color black = Color(0xFF2A2018); // tam siyah yerine espresso
  static const Color error = Color(0xFFB3452F); // sıcak, güven veren kırmızı-toprak
  static const Color onError = Color(0xFFE8A98F);
  static const Color success = Color(0xFF7C8B6F); // yumuşak adaçayı yeşili
  static const Color warning = Color(0xFFC98A3D);
  static const Color info = Color(0xFF5B7C99);

  // --- METİN VE SINIRLAR ---
  static const Color textPrimary = Color(0xFF3E2F23); // ana başlıklar (espresso)
  static const Color textSecondary = Color(0xFF6B5A4A); // açıklama metinleri
  static const Color textTertiary = Color(0xFF9C8D7D); // yardımcı/hint metin
  static const Color textLight = white;

  static const Color border = Color(0xFFE0D2B8); // sıcak, ince ahşap sınırlar
  static const Color divider = Color(0xFFEDE3D3); // çok hafif sıcak ayraçlar

  // --- GRİ TONLAMALARI (Neutral — ahşap tonuna kaydırıldı) ---
  static const Color lightGrey = Color(0xFFEDE3D3);
  static const Color mediumGrey = Color(0xFFD8C7AE);
  static const Color darkGrey = Color(0xFF6B5A4A);

  // --- ARKA PLANLAR ---
  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF2A2018); // koyu mod (pasif)

  // --- MODERN PRIMARY (espresso tonuyla uyumlu) ---
  static const Color primaryDark = Color(0xFF2A2018);
  static const Color primaryLight = Color(0xFF6B5A4A);

  // --- SECONDARY (sıcak ahşap bej geçişleri) ---
  static const Color secondaryDark = Color(0xFFDCCBB0);
  static const Color secondaryLight = Color(0xFFF5EFE6);

  // --- ACCENT (Ceviz/Tarçın kahvesi — markanın sıcak ana vurgusu) ---
  static const Color accent = Color(0xFFA9714B);
  static const Color accentDark = Color(0xFF8C5A3A);
  static const Color accentLight = Color(0xFFC99872);

  // --- İKİNCİ AKSAN (Adaçayı yeşili — organik his) ---
  static const Color sage = Color(0xFF7C8B6F);
  static const Color sageDark = Color(0xFF64715A);
  static const Color sageLight = Color(0xFFA3AF97);

  // --- NEUTRAL UI ---
  static const Color card = Color(0xFFFFFDF9);

  // --- DARK MODE PALETİ (uygulama ThemeMode.light'a sabitli, pasif) ---
  static const Color darkBackground = Color(0xFF2A2018);
  static const Color darkSurface = Color(0xFF382A1F);
  static const Color darkCard = Color(0xFF443528);
  static const Color darkTextPrimary = Color(0xFFF5EFE6);
  static const Color darkTextSecondary = Color(0xFFC9B8A4);
  static const Color darkBorder = Color(0xFF52412F);

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
}
