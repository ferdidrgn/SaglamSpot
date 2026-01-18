import 'package:flutter/material.dart';

class AppColors {
  // --- ANA LÜKS PALET (Emerald & Forest Green Temelli) ---
  static const Color primary =
      Color(0xFF0F302A); // Koyu Orman Yeşili (Lüks hissi)
  static const Color primaryVariant =
      Color(0xFF071F1B); // Daha derin yeşil (Hover/Pres)
  static const Color onPrimary = Color(0xFF4CAF93); // Canlı nane yeşili (Vurgu)

  static const Color surface = Color(0xFFF9FDFB); // Çok hafif yeşil çalan beyaz
  static const Color onSurface =
      Color(0xFF8BAE9E); // Yüzey üzerindeki yumuşak yeşil-gri tonu

  static const Color background = Color(0xFFF8FAF9); // Temiz, modern arka plan

  static const Color secondary =
      Color(0xFFE8F1ED); // Adaçayı Yeşili (Kart içleri için ideal)
  static const Color onSecondary =
      Color(0xFF638C7D); // İkincil alanlardaki metin/ikon rengi
  static const Color secondaryVariant = Color(0xFFD4E2DC); // Hafif koyu adaçayı

  // --- YARDIMCI VE SEMANTİK RENKLER ---
  static const Color white = Colors.white;
  static const Color black =
      Color(0xFF121212); // Tam siyah yerine lüks mat siyah
  static const Color error = Color(0xFFD32F2F); // Güven veren kırmızı
  static const Color onError = Color(0xFFE86060); // Güven veren kırmızı
  static const Color success = Color(0xFF2E7D32); // Uyumlu yeşil başarı rengi
  static const Color warning = Color(0xFFED6C02); // Okunabilir turuncu-sarı
  static const Color info = Color(0xFF0288D1); // Bilgilendirme mavisi

  // --- METİN VE SINIRLAR ---
  static const Color textPrimary =
      Color(0xFF0F302A); // Ana başlıklar için koyu yeşil siyah
  static const Color textSecondary =
      Color(0xFF5A6E6A); // Açıklama metinleri için gri-yeşil
  static const Color textTertiary =
      Color(0xFF94A3B8); // Yardımcı metinler (Hint text)
  static const Color textLight = white; // Koyu zemin üzerindeki beyaz metin

  static const Color border = Color(0xFFE2E8F0); // Modern ve ince sınırlar
  static const Color divider = Color(0xFFF1F5F9); // Çok hafif ayraçlar

  // --- GRİ TONLAMALARI (Neutral) ---
  static const Color lightGrey = Color(0xFFF1F5F9);
  static const Color mediumGrey = Color(0xFFCBD5E1);
  static const Color darkGrey = Color(0xFF334155);

  // --- ARKA PLANLAR ---
  static const Color backgroundLight = white;
  static const Color backgroundDark =
      Color(0xFF0F172A); // Koyu mod için derin lacivert-siyah

  // --- MODERN PRIMARY (Indigo-Based) ---
  // Not: Emerald ana paletinize uyum sağlaması için Indigo tonlarını yumuşattım.
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryLight = Color(0xFF818CF8);

  // --- SECONDARY (Pink-Based) ---
  static const Color secondaryDark = Color(0xFFBE185D);
  static const Color secondaryLight = Color(0xFFF472B6);

  // --- ACCENT (Gold/Altın - Emerald'ın En İyi Tamamlayıcısı) ---
  static const Color accent = Color(0xFFC5A358); // Marka altını
  static const Color accentDark = Color(0xFFA67C52); // Bronza çalan altın
  static const Color accentLight = Color(0xFFE7C8A9); // Krem-altın karışımı

  // --- NEUTRAL UI ---
  static const Color card = Color(0xFFFFFFFF);

  // --- DARK MODE PALETİ (Senkronize Tonlar) ---
  static const Color darkBackground = Color(0xFF0B1210); // Koyu zümrüt siyahı
  static const Color darkSurface = Color(0xFF1A2623); // Koyu yeşil-gri yüzey
  static const Color darkCard = Color(0xFF22302C); // Koyu kart rengi
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF2D3E3A);

  // --- GRADIENT YAPILARI ---
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2D2D), Color(0xFF000000)], // Siyah lüks butonlar için
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, Color(0xFFBDD2C9)], // Adaçayı tonlarında yumuşak geçiş
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark], // Altın geçişi
  );

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, Color(0xFFEDF2F1)], // Beyazdan hafif yeşil-griye
  );
}
