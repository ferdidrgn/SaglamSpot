import 'package:flutter/material.dart';
import 'theme_palette_provider.dart';

class AppColors {
  AppColors._();

  static Brightness _brightness = Brightness.light;
  static ThemePalette _palette = ThemePalette.atelier;

  static void setBrightness(final Brightness value) => _brightness = value;
  static void setPalette(final ThemePalette value) => _palette = value;

  static bool get _dark => _brightness == Brightness.dark;

  // ================================================================
  // ANDROID MATERIAL YOU / "TELEFONUMUN TEMASI" DESTEĞİ
  // ================================================================
  // Kullanıcı Ayarlar'dan "Telefonumun Rengini Kullan"ı açarsa (Android
  // 12+, dynamic_color paketi ile main.dart'ta yakalanır), aşağıdaki
  // KANONİK renk getter'ları sabit marka hex'leri yerine cihazın duvar
  // kağıdından türeyen ColorScheme'i kullanır. Kapalıyken veya şema
  // yoksa (iOS/web/eski Android) hiçbir şey değişmez — sabit palet aynen
  // çalışır. Semantik durum renkleri (error/success/warning/info) VE
  // "dark mode sabit referans" sabitleri BİLEREK dinamikleştirilmedi;
  // onlar markadan/temadan bağımsız anlam taşıyor.
  static bool _useDynamicColor = false;
  static ColorScheme? _dynamicLight;
  static ColorScheme? _dynamicDark;

  static void configureDynamicColor({
    required final bool enabled,
    required final ColorScheme? light,
    required final ColorScheme? dark,
  }) {
    _useDynamicColor = enabled;
    _dynamicLight = light;
    _dynamicDark = dark;
  }

  static ColorScheme? get _dynamicScheme {
    if (!_useDynamicColor) return null;
    return _dark ? _dynamicDark : _dynamicLight;
  }

  static ColorScheme get _paletteScheme {
    if (_dark) {
      return switch (_palette) {
        ThemePalette.atelier => const ColorScheme.dark(
            primary: Color(0xFFFFB329),
            onPrimary: Color(0xFF241800),
            primaryContainer: Color(0xFF493000),
            secondary: Color(0xFFB5C3F5),
            onSecondary: Color(0xFF1B2035),
            secondaryContainer: Color(0xFF30364D),
            surface: Color(0xFF101522),
            surfaceContainer: Color(0xFF171D2A),
            surfaceContainerHigh: Color(0xFF202838),
            surfaceContainerHighest: Color(0xFF2A3345),
            onSurface: Color(0xFFF2F3FA),
            onSurfaceVariant: Color(0xFFC2C5D3),
            outline: Color(0xFF74798A),
            outlineVariant: Color(0xFF454B5D),
            error: Color(0xFFFFB4A9),
          ),
        ThemePalette.lavender => const ColorScheme.dark(
            primary: Color(0xFFB99BFF),
            onPrimary: Color(0xFF27105B),
            primaryContainer: Color(0xFF432483),
            secondary: Color(0xFFE4B7F4),
            onSecondary: Color(0xFF341A3D),
            secondaryContainer: Color(0xFF4B3155),
            surface: Color(0xFF171322),
            surfaceContainer: Color(0xFF201A2D),
            surfaceContainerHigh: Color(0xFF292238),
            surfaceContainerHighest: Color(0xFF342D44),
            onSurface: Color(0xFFF5F0FC),
            onSurfaceVariant: Color(0xFFD0C5DF),
            outline: Color(0xFF8A7B9A),
            outlineVariant: Color(0xFF50465D),
            error: Color(0xFFFFB4AB),
          ),
        ThemePalette.midnight => const ColorScheme.dark(
            primary: Color(0xFF83A2FF),
            onPrimary: Color(0xFF10234D),
            primaryContainer: Color(0xFF243E73),
            secondary: Color(0xFFAFC7FF),
            onSecondary: Color(0xFF14284B),
            secondaryContainer: Color(0xFF263956),
            surface: Color(0xFF080F18),
            surfaceContainer: Color(0xFF0E1722),
            surfaceContainerHigh: Color(0xFF151F2D),
            surfaceContainerHighest: Color(0xFF202C3C),
            onSurface: Color(0xFFF3F6FC),
            onSurfaceVariant: Color(0xFFC3CCDA),
            outline: Color(0xFF78869B),
            outlineVariant: Color(0xFF455164),
            error: Color(0xFFFFB4AB),
          ),
      };
    }

    return switch (_palette) {
      ThemePalette.atelier => const ColorScheme.light(
          primary: Color(0xFF202238),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFDDE2F6),
          secondary: Color(0xFFF3A000),
          onSecondary: Color(0xFF241800),
          secondaryContainer: Color(0xFFFFE2AC),
          surface: Color(0xFFE2E6F6),
          surfaceContainer: Color(0xFFF1F3FA),
          surfaceContainerHigh: Color(0xFFFFFFFF),
          surfaceContainerHighest: Color(0xFFF9FAFD),
          onSurface: Color(0xFF1B1C24),
          onSurfaceVariant: Color(0xFF545766),
          outline: Color(0xFF777B8A),
          outlineVariant: Color(0xFFD7DAE6),
          error: Color(0xFFBA1A1A),
        ),
      ThemePalette.lavender => const ColorScheme.light(
          primary: Color(0xFF6736D3),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE7DCFF),
          secondary: Color(0xFF9367DD),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF0E8FF),
          surface: Color(0xFFF0EBFA),
          surfaceContainer: Color(0xFFF8F5FE),
          surfaceContainerHigh: Color(0xFFFFFFFF),
          surfaceContainerHighest: Color(0xFFFBF9FE),
          onSurface: Color(0xFF211A2B),
          onSurfaceVariant: Color(0xFF62596F),
          outline: Color(0xFF81768F),
          outlineVariant: Color(0xFFE1DAEA),
          error: Color(0xFFBA1A1A),
        ),
      ThemePalette.midnight => const ColorScheme.light(
          primary: Color(0xFF345AAE),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFDCE6FF),
          secondary: Color(0xFF587BCB),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFE8EEFF),
          surface: Color(0xFFEAF0FB),
          surfaceContainer: Color(0xFFF3F6FD),
          surfaceContainerHigh: Color(0xFFFFFFFF),
          surfaceContainerHighest: Color(0xFFF9FAFE),
          onSurface: Color(0xFF161D2B),
          onSurfaceVariant: Color(0xFF4C5668),
          outline: Color(0xFF747F92),
          outlineVariant: Color(0xFFD6DCE7),
          error: Color(0xFFBA1A1A),
        ),
    };
  }

  static Color _darken(final Color color, [final double amount = 0.18]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  // ================================================================
  // KANONİK RENKLER — tüm diğer isimler bunlara işaret eder.
  // ================================================================
  static const Color white = Colors.white;
  static const Color black = Color(0xFF332925);
  static const Color textLight = white;

  static Color get primary => _dynamicScheme?.primary ?? _paletteScheme.primary;
  static Color get primaryDark => _dynamicScheme != null
      ? _darken(_dynamicScheme!.primary)
      : _darken(_paletteScheme.primary);
  static Color get primaryLight =>
      _dynamicScheme?.primaryContainer ?? _paletteScheme.primaryContainer;

  static Color get accent =>
      _dynamicScheme?.tertiary ?? _paletteScheme.secondary;
  static Color get accentDark => _dynamicScheme != null
      ? _darken(_dynamicScheme!.tertiary)
      : _darken(_paletteScheme.secondary);
  static Color get accentLight =>
      _dynamicScheme?.tertiaryContainer ?? _paletteScheme.secondaryContainer;

  // Koyu temada "surface/card" bilerek zeminden BELİRGİN şekilde daha açık
  // tutuluyor (gerçek bir "elevated card" hissi için) — önceki sürümde
  // hepsi birbirine çok yakın koyu kahve tonlarıydı ve her şey birbirine
  // karışıyordu.
  static Color get background =>
      _dynamicScheme?.surface ?? _paletteScheme.surface;
  static Color get surface =>
      _dynamicScheme?.surfaceContainerHigh ??
      _paletteScheme.surfaceContainerHigh;
  static Color get secondary =>
      _dynamicScheme?.surfaceContainer ?? _paletteScheme.surfaceContainer;
  static Color get secondaryVariant =>
      _dynamicScheme?.surfaceContainerHighest ??
      _paletteScheme.surfaceContainerHighest;

  static Color get muted =>
      _dynamicScheme?.outlineVariant ?? _paletteScheme.outlineVariant;
  static Color get mutedDark =>
      _dynamicScheme?.outline ?? _paletteScheme.outline;

  static Color get textPrimary =>
      _dynamicScheme?.onSurface ?? _paletteScheme.onSurface;
  static Color get textSecondary =>
      _dynamicScheme?.onSurfaceVariant ?? _paletteScheme.onSurfaceVariant;
  static Color get textTertiary => _dynamicScheme != null
      ? Color.lerp(
          _dynamicScheme!.onSurfaceVariant, _dynamicScheme!.surface, 0.35)!
      : Color.lerp(
          _paletteScheme.onSurfaceVariant, _paletteScheme.surface, 0.35)!;

  static Color get border =>
      _dynamicScheme?.outlineVariant ?? _paletteScheme.outlineVariant;
  static Color get divider =>
      _dynamicScheme?.outlineVariant ?? _paletteScheme.outlineVariant;

  // --- SEMANTİK RENKLER (durum bildirimi — markadan bağımsız) ---
  static Color get error =>
      _dark ? const Color(0xFFE08A70) : const Color(0xFFB4543A);
  static Color get onError => const Color(0xFFE0917A);
  static Color get success =>
      _dark ? const Color(0xFFA8C296) : const Color(0xFF7C8B6F);
  static Color get warning =>
      _dark ? const Color(0xFFE8B984) : const Color(0xFFC98A4B);
  static Color get info =>
      _dark ? const Color(0xFF9DB2C7) : const Color(0xFF6E7D8F);

  static Color get sage => success;
  static Color get sageDark =>
      _dark ? const Color(0xFF8A9F79) : const Color(0xFF62705A);
  static Color get sageLight =>
      _dark ? const Color(0xFFCEDABF) : const Color(0xFFA3AE97);

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
  static Color get primaryVariant =>
      _dynamicScheme?.primaryContainer ?? _paletteScheme.primaryContainer;
  static Color get onPrimary =>
      _dynamicScheme?.onPrimary ?? _paletteScheme.onPrimary;
  static Color get onSecondary =>
      _dynamicScheme?.onSecondary ?? _paletteScheme.onSecondary;
  static Color get onSurface => textPrimary;

  static Color get lightGrey => secondary;
  static Color get mediumGrey => muted;
  static Color get darkGrey => textSecondary;

  static Color get backgroundLight => white;
  static Color get backgroundDark => const Color(0xFF1B1714);

  static Color get secondaryDark =>
      _dark ? const Color(0xFFAAA75F) : const Color(0xFF914933);
  static Color get secondaryLight =>
      _dark ? const Color(0xFFE9E6B2) : const Color(0xFFE7B39F);

  static Color get card => surface;

  // Dark mode sabit referans değerleri (koyu tema AÇIKKEN de, parlaklıktan
  // bağımsız olarak "kesin koyu" bir ton lazım olduğunda kullanılır).
  static const Color darkBackground = Color(0xFF1B1714);
  static const Color darkSurface = Color(0xFF312824);
  static const Color darkCard = Color(0xFF3B302A);
  static const Color darkTextPrimary = Color(0xFFF4E9E3);
  static const Color darkTextSecondary = Color(0xFFCEBFB7);
  static const Color darkBorder = Color(0xFF594A43);

  // Açık mod sabit referans değerleri — darkBackground/darkTextPrimary'nin
  // açık temadaki eşleniği, brightness getter'larındaki AYNI hex'ler
  // (yeni renk değil). Native açılış ekranı (flutter_native_splash) işletim
  // sisteminin kendi açık/koyu ayarına göre renk seçer — bunu izleyen
  // Flutter katmanının (AppLaunchSplashOverlay) UYGULAMANIN kendi tema
  // tercihi yerine AYNI işletim sistemi parlaklığına bakması gerekir; aksi
  // halde uygulama varsayılanı "açık" iken cihaz koyu modundaysa native
  // splash koyu, hemen ardından gelen Flutter katmanı açık renkte açılıp
  // rahatsız edici bir renk sıçraması/"bozukluk" hissi yaratıyordu.
  static const Color lightBackground = Color(0xFFFFF9FC);
  static const Color lightTextPrimary = Color(0xFF352C29);
  static const Color lightTextSecondary = Color(0xFF6E5F59);

  // Beyaz logo/ikon/metin taşıyan "marka plakası" yüzeyler (Ayarlar profil
  // kartı, açılış ekranı) için — primary/accent gibi parlaklığa göre TERS
  // dönen getter'lar burada kullanılırsa koyu temada açık altın zemin +
  // beyaz yazı neredeyse görünmez olur. Bunun yerine her iki temada da
  // AYNI, sabit koyu espresso tonu: her zaman yüksek kontrast.
  static const Gradient brandPlateGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkCard, black],
  );

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
