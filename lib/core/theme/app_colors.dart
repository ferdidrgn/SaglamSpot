import 'package:flutter/material.dart';

class AppColors {
  // --- ANA LÜKS PALET ---
  static const Color primary =
      Color(0xFF0F302A); // Derin Nane (Dark Mint) - Butonlar ve Başlıklar
  static const Color background =
      Color(0xFFF8FAF9); // Ferah Beyaz-Mint - Arka Planlar
  static const Color accent =
      Color(0xFFC5A358); // Mat Altın (Gold) - Vurgular ve Rozetler

  // --- YARDIMCI RENKLER ---
  static const Color white = Colors.white;
  static const Color error = Color(0xFFDC3545);
  static const Color textPrimary = Color(0xFF0F302A);
  static const Color textSecondary = Color(0xFF6A7D7A); // Gri-Yeşil tonu
  static const Color border = Color(0xFFDDECE8);

  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFD4D4D4);
  static const Color darkGrey = Color(0xFF333333);
  static const Color black = Colors.black;

// Özel Renkler
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);

// Metin Renkleri
  static const Color textLight = white;

// Arka Plan Renkleri
  static const Color backgroundLight = white;
  static const Color backgroundDark = darkGrey;

  static const Color surface = Color(0xFFF9FDFB);

  static const Color secondary = Color(0xFFE8F1ED); // Sage Green (Kart içleri)

  static const Color textTertiary = Color(0xFFA0A0A0);

// Görseldeki siyah butonlar için gradient (opsiyonel)
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2D2D), Color(0xFF000000)],
  );

// Modern Primary Colors (Indigo based)
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF8B87EA);

// Secondary Colors (Pink based)
  static const Color secondaryDark = Color(0xFFDB2777);
  static const Color secondaryLight = Color(0xFFF472B6);

// Accent Colors (Emerald based)
  static const Color accentDark = Color(0xFFBC8A5F);
  static const Color accentLight = Color(0xFFE7C8A9);

// Neutral Colors
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFF1F5F9);

// Semantic Colors
  static const Color info = Color(0xFF3B82F6);

// Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkBorder = Color(0xFF334155);

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, Color(0xFFF1F5F9)],
  );
}
