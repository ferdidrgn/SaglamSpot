import 'package:flutter/material.dart';

/// TEK MARKA PALETİ — "Sağlam Spot" logosundaki ahşap/bronz kurdele
/// amblemine göre: sıcak ekru zemin + espresso kahvesi metin + ceviz/
/// tarçın bronz vurgu. Web ve native mobil AYNI paleti kullanır.
/// Önceki turdaki soğuk teal palet tamamen terk edildi; kullanıcının
/// paylaştığı logo referanslarındaki sıcak, "mobilya butiği" hissi
/// esas alındı. Aşağıdaki eski isimler (primary, mobilePrimary, vb.)
/// hâlâ var ama hepsi aynı tek palete işaret ediyor — böylece uygulama
/// genelindeki yüzlerce çağrı noktası tek tek değiştirilmeden tutarlı
/// renk alır.
class AppColors {
  // ================================================================
  // KANONİK RENKLER — tüm diğer isimler bunlara işaret eder.
  // ================================================================
  static const Color white = Colors.white;

  static const Color primary = Color(0xFF3E2F23); // koyu espresso kahve
  static const Color primaryDark = Color(0xFF241A13); // en koyu espresso
  static const Color primaryLight = Color(0xFF6B5744); // hover/basılı durum

  static const Color accent = Color(0xFFA9714B); // ceviz/tarçın bronz vurgu (logo rengi)
  static const Color accentDark = Color(0xFF8B5A3A);
  static const Color accentLight = Color(0xFFC79868);

  static const Color background = Color(0xFFF5EFE6); // sıcak ekru/krem zemin
  static const Color surface = Color(0xFFFFFDF9); // kırık beyaz kart zemini
  static const Color secondary = Color(0xFFEDE3D3); // açık ahşap bej ikincil zemin
  static const Color secondaryVariant = Color(0xFFE0D3BC); // koyu ahşap bej

  static const Color muted = Color(0xFFCFC0A8); // sıcak gri-bej
  static const Color mutedDark = Color(0xFFB5A488); // kenarlık/pasif ikon

  static const Color textPrimary = Color(0xFF3E2F23);
  static const Color textSecondary = Color(0xFF6B5744);
  static const Color textTertiary = Color(0xFF8F7D6B);
  static const Color textLight = white;

  static const Color border = Color(0xFFE0D3BC);
  static const Color divider = Color(0xFFEDE3D3);

  static const Color black = Color(0xFF2A1F17);

  // --- SEMANTİK RENKLER (durum bildirimi — markadan bağımsız) ---
  static const Color error = Color(0xFFB4543A);
  static const Color onError = Color(0xFFE0917A);
  static const Color success = Color(0xFF7C8B6F);
  static const Color warning = Color(0xFFC98A4B);
  static const Color info = Color(0xFF6E7D8F);

  static const Color sage = success;
  static const Color sageDark = Color(0xFF62705A);
  static const Color sageLight = Color(0xFFA3AE97);

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A3A2C), primary],
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
  // GERİYE DÖNÜK İSİMLER — bu proje aylardır bu adlarla (primaryVariant,
  // onPrimary, lightGrey, darkGrey vb.) yazıldığı için yüzlerce dosyada
  // bu adlar geçiyor. Hepsini tek tek değiştirmek yerine burada tek
  // palete alias'lanıyorlar.
  // ================================================================
  static const Color primaryVariant = Color(0xFF2A1F17);
  static const Color onPrimary = accent;
  static const Color onSecondary = primary;
  static const Color onSurface = textPrimary;

  static const Color lightGrey = secondary;
  static const Color mediumGrey = muted;
  static const Color darkGrey = textSecondary;

  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF241A13);

  static const Color secondaryDark = Color(0xFF8B5A3A);
  static const Color secondaryLight = Color(0xFFC79868);

  static const Color card = surface;

  // Dark mode (uygulama ThemeMode.light'a sabitli, şu an pasif)
  static const Color darkBackground = Color(0xFF241A13);
  static const Color darkSurface = Color(0xFF32251C);
  static const Color darkCard = Color(0xFF3D2D22);
  static const Color darkTextPrimary = Color(0xFFEDE3D3);
  static const Color darkTextSecondary = Color(0xFFC2B29B);
  static const Color darkBorder = Color(0xFF4A3A2C);

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
