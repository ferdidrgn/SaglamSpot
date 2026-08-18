import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Brightness _brightness = Brightness.light;

  static void setBrightness(final Brightness value) => _brightness = value;

  static bool get _dark => _brightness == Brightness.dark;

  // ================================================================
  // KANONİK RENKLER — tüm diğer isimler bunlara işaret eder.
  // ================================================================
  static const Color white = Colors.white;
  static const Color black = Color(0xFF2A1F17);
  static const Color textLight = white;

  static Color get primary => _dark ? const Color(0xFFE0B074) : const Color(0xFF3E2F23);
  static Color get primaryDark => _dark ? const Color(0xFFC79868) : const Color(0xFF241A13);
  static Color get primaryLight => _dark ? const Color(0xFFF0D4A8) : const Color(0xFF6B5744);

  static Color get accent => _dark ? const Color(0xFFE8B573) : const Color(0xFFA9714B);
  static Color get accentDark => _dark ? const Color(0xFFD09850) : const Color(0xFF8B5A3A);
  static Color get accentLight => _dark ? const Color(0xFFF2D4A0) : const Color(0xFFC79868);

  // Koyu temada "surface/card" bilerek zeminden BELİRGİN şekilde daha açık
  // tutuluyor (gerçek bir "elevated card" hissi için) — önceki sürümde
  // hepsi birbirine çok yakın koyu kahve tonlarıydı ve her şey birbirine
  // karışıyordu.
  static Color get background => _dark ? const Color(0xFF1C140E) : const Color(0xFFF5EFE6);
  static Color get surface => _dark ? const Color(0xFF3D2E22) : const Color(0xFFFFFDF9);
  static Color get secondary => _dark ? const Color(0xFF4A3826) : const Color(0xFFEDE3D3);
  static Color get secondaryVariant => _dark ? const Color(0xFF5C4630) : const Color(0xFFE0D3BC);

  static Color get muted => _dark ? const Color(0xFF8A7560) : const Color(0xFFCFC0A8);
  static Color get mutedDark => _dark ? const Color(0xFFA8927A) : const Color(0xFFB5A488);

  static Color get textPrimary => _dark ? const Color(0xFFF7F0E6) : const Color(0xFF3E2F23);
  static Color get textSecondary => _dark ? const Color(0xFFDCCBB4) : const Color(0xFF6B5744);
  static Color get textTertiary => _dark ? const Color(0xFFB4A088) : const Color(0xFF8F7D6B);

  static Color get border => _dark ? const Color(0xFF5C4630) : const Color(0xFFE0D3BC);
  static Color get divider => _dark ? const Color(0xFF4A3826) : const Color(0xFFEDE3D3);

  // --- SEMANTİK RENKLER (durum bildirimi — markadan bağımsız) ---
  static Color get error => _dark ? const Color(0xFFE08A70) : const Color(0xFFB4543A);
  static Color get onError => const Color(0xFFE0917A);
  static Color get success => _dark ? const Color(0xFFA8C296) : const Color(0xFF7C8B6F);
  static Color get warning => _dark ? const Color(0xFFE8B984) : const Color(0xFFC98A4B);
  static Color get info => _dark ? const Color(0xFF9DB2C7) : const Color(0xFF6E7D8F);

  static Color get sage => success;
  static Color get sageDark => _dark ? const Color(0xFF8A9F79) : const Color(0xFF62705A);
  static Color get sageLight => _dark ? const Color(0xFFCEDABF) : const Color(0xFFA3AE97);

  static Gradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryLight, primary],
      );

  static Gradient get secondaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [secondary, secondaryVariant],
      );

  static Gradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, accentDark],
      );

  static Gradient get sageGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [sage, sageDark],
      );

  static Gradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [background, secondary],
      );

  // ================================================================
  // GERİYE DÖNÜK İSİMLER
  // ================================================================
  static Color get primaryVariant => _dark ? const Color(0xFF1A120C) : const Color(0xFF2A1F17);
  static Color get onPrimary => accent;
  static Color get onSecondary => primary;
  static Color get onSurface => textPrimary;

  static Color get lightGrey => secondary;
  static Color get mediumGrey => muted;
  static Color get darkGrey => textSecondary;

  static Color get backgroundLight => white;
  static Color get backgroundDark => const Color(0xFF241A13);

  static Color get secondaryDark => _dark ? const Color(0xFFC79868) : const Color(0xFF8B5A3A);
  static Color get secondaryLight => _dark ? const Color(0xFFEDD4B0) : const Color(0xFFC79868);

  static Color get card => surface;

  // Dark mode sabit referans değerleri (koyu tema AÇIKKEN de, parlaklıktan
  // bağımsız olarak "kesin koyu" bir ton lazım olduğunda kullanılır).
  static const Color darkBackground = Color(0xFF1C140E);
  static const Color darkSurface = Color(0xFF3D2E22);
  static const Color darkCard = Color(0xFF4A3826);
  static const Color darkTextPrimary = Color(0xFFF7F0E6);
  static const Color darkTextSecondary = Color(0xFFDCCBB4);
  static const Color darkBorder = Color(0xFF5C4630);

  // ================================================================
  // "mobile*" İSİMLERİ
  // ================================================================
  static Color get mobilePrimary => primary;
  static Color get mobilePrimaryDark => primaryDark;
  static Color get mobilePrimaryLight => primaryLight;

  static Color get mobileAccent => accent;
  static Color get mobileAccentDark => accentDark;
  static Color get mobileAccentLight => accentLight;

  static Color get mobileBackground => background;
  static Color get mobileSurface => surface;
  static Color get mobileCardBg => secondary;
  static Color get mobileSecondaryBg => secondaryVariant;

  static Color get mobileMuted => muted;
  static Color get mobileMutedDark => mutedDark;

  static Color get mobileTextPrimary => textPrimary;
  static Color get mobileTextSecondary => textSecondary;
  static Color get mobileTextTertiary => textTertiary;
  static Color get mobileBorder => border;

  static Gradient get mobileAccentGradient => accentGradient;
  static Gradient get mobilePrimaryGradient => primaryGradient;
}
