import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografi sistemi: başlıklarda sıcak/organik bir his veren kalın serif
/// (Fraunces), gövde metinde temiz bir sans-serif (Inter). İkisi de
/// google_fonts üzerinden yüklenir; [fontFamily] geriye dönük uyumluluk
/// için hâlâ Inter ailesini işaret eder (ThemeData.fontFamily varsayılanı).
class AppTextStyles {
  static final String fontFamily = GoogleFonts.inter().fontFamily!;

  /// Başlıklarda kullanılacak sıcak/organik serif ailesi (Fraunces).
  /// Hazır TextTheme stillerinin dışında, elle yazılmış başlık
  /// TextStyle'larına eklemek için kullanılır.
  static final String headingFontFamily = GoogleFonts.fraunces().fontFamily!;

  static TextStyle _heading({
    required final double fontSize,
    required final FontWeight fontWeight,
    final double? letterSpacing,
    required final double height,
  }) =>
      GoogleFonts.fraunces(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle _body({
    required final double fontSize,
    required final FontWeight fontWeight,
    final double? letterSpacing,
    required final double height,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  // MOBİL TİPOGRAFİ (Material 3 Standartları)
  // ---------------------------------------------------------------------------
  static final TextTheme mobileTextTheme = TextTheme(
    displayLarge: _heading(
        fontSize: 57.0, fontWeight: FontWeight.w600, letterSpacing: -0.25, height: 1.12),
    displayMedium: _heading(fontSize: 45.0, fontWeight: FontWeight.w600, height: 1.16),
    displaySmall: _heading(fontSize: 36.0, fontWeight: FontWeight.w600, height: 1.22),
    headlineLarge: _heading(fontSize: 32.0, fontWeight: FontWeight.w600, height: 1.25),
    headlineMedium: _heading(fontSize: 28.0, fontWeight: FontWeight.w600, height: 1.29),
    headlineSmall: _heading(fontSize: 24.0, fontWeight: FontWeight.w600, height: 1.33),
    titleLarge: _heading(fontSize: 22.0, fontWeight: FontWeight.w600, height: 1.27),
    titleMedium: _body(
        fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 1.5),
    titleSmall: _body(
        fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
    bodyLarge: _body(
        fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5, height: 1.5),
    bodyMedium: _body(
        fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.43),
    bodySmall: _body(
        fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.33),
    labelLarge: _body(
        fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
    labelMedium: _body(
        fontSize: 12.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.33),
    labelSmall: _body(
        fontSize: 11.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.45),
  );

  // WEB TİPOGRAFİ (Daha Büyük Ekranlar İçin Optimize Edilmiş)
  // ---------------------------------------------------------------------------
  static final TextTheme webTextTheme = TextTheme(
    displayLarge: _heading(
        fontSize: 64.0, fontWeight: FontWeight.w600, letterSpacing: -0.25, height: 1.12),
    displayMedium: _heading(fontSize: 52.0, fontWeight: FontWeight.w600, height: 1.16),
    displaySmall: _heading(fontSize: 44.0, fontWeight: FontWeight.w600, height: 1.22),
    headlineLarge: _heading(fontSize: 40.0, fontWeight: FontWeight.w600, height: 1.25),
    headlineMedium: _heading(fontSize: 34.0, fontWeight: FontWeight.w600, height: 1.29),
    headlineSmall: _heading(fontSize: 28.0, fontWeight: FontWeight.w600, height: 1.33),
    titleLarge: _heading(fontSize: 24.0, fontWeight: FontWeight.w600, height: 1.27),
    titleMedium: _body(
        fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 1.5),
    titleSmall: _body(
        fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
    bodyLarge: _body(
        fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 0.5, height: 1.5),
    // Okuma kolaylığı için büyütüldü
    bodyMedium: _body(
        fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.43),
    bodySmall: _body(
        fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.33),
    labelLarge: _body(
        fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
    labelMedium: _body(
        fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.33),
    labelSmall: _body(
        fontSize: 12.0, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.45),
  );
}
