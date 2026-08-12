import 'package:flutter/material.dart';

/// TEK MARKA PALETİ — "Furnishify" referansından: koyu petrol-teal +
/// sıcak amber vurgu. Web ve native mobil artık AYNI paleti kullanır.
/// Eski sıcak espresso/ahşap palet tamamen kaldırıldı; aşağıdaki eski
/// isimler (primary, background, textPrimary, mobilePrimary, vb.) hâlâ
/// var ama hepsi aynı tek palete işaret ediyor — böylece uygulama
/// genelindeki yüzlerce çağrı noktasını tek tek değiştirmeden renk
/// tutarlılığı sağlanıyor.
class AppColors {
  // ================================================================
  // KANONİK RENKLER — tüm diğer isimler bunlara işaret eder.
  // ================================================================
  static const Color white = Colors.white;

  static const Color primary = Color(0xFF2F4B4E); // koyu teal
  static const Color primaryDark = Color(0xFF152223); // neredeyse siyah teal
  static const Color primaryLight = Color(0xFF3F6367); // hover/basılı durum

  static const Color accent = Color(0xFFE2A54B); // sıcak amber vurgu
  static const Color accentDark = Color(0xFFC98A34);
  static const Color accentLight = Color(0xFFEDC080);

  static const Color background = white;
  static const Color surface = white;
  static const Color secondary = Color(0xFFF3F5F5); // açık gri-teal ikincil zemin
  static const Color secondaryVariant = Color(0xFFEFF2F2);

  static const Color muted = Color(0xFFBFC7C8); // adaçayı grisi
  static const Color mutedDark = Color(0xFFA5B3B4); // kenarlık/pasif ikon

  static const Color textPrimary = Color(0xFF152223);
  static const Color textSecondary = Color(0xFF3A4D4E);
  static const Color textTertiary = Color(0xFF6B7B7C);
  static const Color textLight = white;

  static const Color border = Color(0xFFDCDEDE);
  static const Color divider = Color(0xFFDCDEDE);

  static const Color black = primaryDark;

  // --- SEMANTİK RENKLER (durum bildirimi — markadan bağımsız) ---
  static const Color error = Color(0xFFC0533F);
  static const Color onError = Color(0xFFE0917A);
  static const Color success = Color(0xFF3F7D5C);
  static const Color warning = accentDark;
  static const Color info = primaryLight;

  static const Color sage = success;
  static const Color sageDark = Color(0xFF2E5A41);
  static const Color sageLight = Color(0xFF6FA381);

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryVariant],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const Gradient sageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sage, sageDark],
  );

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, secondary],
  );

  // ================================================================
  // GERİYE DÖNÜK İSİMLER — bu proje aylardır "sıcak espresso" adlarıyla
  // yazıldığı için (primaryVariant, onPrimary, lightGrey, darkGrey vb.)
  // yüzlerce dosyada bu adlar geçiyor. Hepsini tek tek değiştirmek yerine
  // burada tek palete alias'lanıyorlar.
  // ================================================================
  static const Color primaryVariant = primaryDark;
  static const Color onPrimary = accent;
  static const Color onSecondary = primary;
  static const Color onSurface = textPrimary;

  static const Color lightGrey = secondary;
  static const Color mediumGrey = muted;
  static const Color darkGrey = textSecondary;

  static const Color backgroundLight = white;
  static const Color backgroundDark = primaryDark;

  static const Color secondaryDark = mutedDark;
  static const Color secondaryLight = muted;

  static const Color card = white;

  // Dark mode (uygulama ThemeMode.light'a sabitli, şu an pasif)
  static const Color darkBackground = primaryDark;
  static const Color darkSurface = Color(0xFF1E3436);
  static const Color darkCard = Color(0xFF23393B);
  static const Color darkTextPrimary = Color(0xFFDCDEDE);
  static const Color darkTextSecondary = muted;
  static const Color darkBorder = primaryLight;

  // ================================================================
  // "mobile*" İSİMLERİ — geriye dönük uyumluluk için korunuyor. Artık
  // yukarıdakiyle birebir aynı değerler; platforma göre farklı renk YOK.
  // ================================================================
  static const Color mobilePrimary = primary;
  static const Color mobilePrimaryDark = primaryDark;
  static const Color mobilePrimaryLight = primaryLight;

  static const Color mobileAccent = accent;
  static const Color mobileAccentDark = accentDark;
  static const Color mobileAccentLight = accentLight;

  static const Color mobileBackground = background;
  static const Color mobileSurface = surface;
  static const Color mobileCardBg = secondary;
  static const Color mobileSecondaryBg = secondaryVariant;

  static const Color mobileMuted = muted;
  static const Color mobileMutedDark = mutedDark;

  static const Color mobileTextPrimary = textPrimary;
  static const Color mobileTextSecondary = textSecondary;
  static const Color mobileTextTertiary = textTertiary;
  static const Color mobileBorder = border;

  static const Gradient mobileAccentGradient = accentGradient;
  static const Gradient mobilePrimaryGradient = primaryGradient;
}
