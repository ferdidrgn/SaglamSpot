import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF1F7F6);
  static const Color surface = Color(0xFFF9FDFB);

// Aksanlar ve Butonlar
  static const Color primary = Color(0xFF1A1A1A); // Modern siyah/antrasit
  static const Color secondary = Color(0xFFE8F1ED); // Sage Green (Kart içleri)

  // Yazı ve Kenarlık
  static const Color textPrimary =
      Color(0xFF103E35); // Çok koyu yeşil bazlı siyah
  static const Color textSecondary = Color(0xFF5A7D76); // Orta tonlu mint gri
  static const Color border = Color(0xFFDDECE8);
  static const Color textTertiary = Color(0xFFA0A0A0);

// Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

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
  static const Color accent = Color(0xFFD4A373); // Toprak/Bakır tonu (CTA için)
  static const Color accentDark = Color(0xFFBC8A5F);
  static const Color accentLight = Color(0xFFE7C8A9);

  // Neutral Colors
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFF1F5F9);

  // Semantic Colors
  static const Color warning = Color(0xFFF59E0B);
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
