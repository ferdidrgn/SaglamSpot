import 'package:flutter/foundation.dart'; // kIsWeb için gerekli
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

final appThemeProvider = Provider<AppTheme>((final ref) {
  return AppTheme();
});

class AppTheme {
  // --- Yardımcı Metot: Platforma Göre TextTheme Seçimi ve Renklendirme ---
  TextTheme _getTextTheme(final Brightness brightness, final ColorScheme colors) {
    // 1. Platforma göre (Web/Mobil) ana şablonu seçiyoruz
    final TextTheme baseTheme =
        kIsWeb ? AppTextStyles.webTextTheme : AppTextStyles.mobileTextTheme;

    // 2. Şablonu mevcut renk paletiyle (Light/Dark) boyuyoruz
    return baseTheme.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
      decorationColor: colors.onSurface,
    );
  }

  ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      // Koyu yeşil üzerine beyaz metin
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      // Material 3 yeni yüzey renkleri
      surfaceContainerHighest: AppColors.surface,
      outline: AppColors.border,
      shadow: Colors.black,
    );

    // Yeni TextTheme entegrasyonu
    final textTheme = _getTextTheme(Brightness.light, colorScheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      // Global font ailesi
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      // --- Metotların Kullanımı ---
      appBarTheme: _appBarTheme(
        colors: colorScheme,
        textTheme: textTheme,
        bgColor: AppColors.background,
      ),
      cardTheme: _cardTheme(colors: colorScheme, bgColor: AppColors.background),
      elevatedButtonTheme: _elevatedButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!, // Şablondaki stili kullan
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!,
      ),
      textButtonTheme: _textButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!,
      ),
      inputDecorationTheme: _inputDecorationTheme(colors: colorScheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(colors: colorScheme),
      navigationBarTheme: _navigationBarTheme(colors: colorScheme),
      chipTheme: _chipTheme(colors: colorScheme, textTheme: textTheme),
      tabBarTheme: _tabBarTheme(colors: colorScheme, textTheme: textTheme),
      dividerTheme: DividerThemeData(
          color: colorScheme.outline.withOpacity(0.3), thickness: 1, space: 1),
      floatingActionButtonTheme: _fabTheme(colors: colorScheme),
      snackBarTheme: _snackBarTheme(colors: colorScheme, textTheme: textTheme),
    );
  }

  ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.onPrimary,
      // Dark modda daha açık bir yeşil vurgu için
      onPrimary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.darkCard,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      // Material 3 yeni yüzey renkleri
      surfaceContainerHighest: AppColors.darkSurface,
      outline: AppColors.darkBorder,
      shadow: Colors.black,
    );

    // Yeni TextTheme entegrasyonu
    final textTheme = _getTextTheme(Brightness.dark, colorScheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      // Global font ailesi
      brightness: Brightness.dark,
      primaryColor: AppColors.darkBackground,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      textTheme: textTheme,
      // --- Metotların Kullanımı ---
      appBarTheme: _appBarTheme(
        colors: colorScheme,
        textTheme: textTheme,
        bgColor: AppColors.darkBackground,
      ),
      cardTheme:
          _cardTheme(colors: colorScheme, bgColor: AppColors.darkBackground),
      elevatedButtonTheme: _elevatedButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!,
      ),
      textButtonTheme: _textButtonTheme(
        colors: colorScheme,
        textStyle: textTheme.labelLarge!,
      ),
      inputDecorationTheme: _inputDecorationTheme(colors: colorScheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(colors: colorScheme),
      navigationBarTheme: _navigationBarTheme(colors: colorScheme),
      chipTheme: _chipTheme(colors: colorScheme, textTheme: textTheme),
      tabBarTheme: _tabBarTheme(colors: colorScheme, textTheme: textTheme),
      dividerTheme: DividerThemeData(
          color: colorScheme.outline.withOpacity(0.3), thickness: 1, space: 1),
      floatingActionButtonTheme: _fabTheme(colors: colorScheme),
      snackBarTheme: _snackBarTheme(colors: colorScheme, textTheme: textTheme),
    );
  }

  // --- Statik Metotlar ---
  static AppBarTheme _appBarTheme({
    required final ColorScheme colors,
    required final TextTheme textTheme,
    required final Color bgColor,
  }) =>
      AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.onSurface, size: 28),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.onSurface,
        ),
        systemOverlayStyle: colors.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      );

  static CardThemeData _cardTheme({
    required final ColorScheme colors,
    required final Color bgColor,
  }) {
    final cardColor = HSLColor.fromColor(bgColor)
        .withLightness(
            (HSLColor.fromColor(bgColor).lightness + 0.05).clamp(0.0, 1.0))
        .toColor();
    return CardThemeData(
      color: colors.brightness == Brightness.dark ? cardColor : colors.surface,
      elevation: 2,
      shadowColor: colors.shadow.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      margin: EdgeInsets.zero,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required final ColorScheme colors,
    required final TextStyle textStyle,
  }) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 0,
          textStyle: textStyle,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme({
    required final ColorScheme colors,
    required final TextStyle textStyle,
  }) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: textStyle,
          side: BorderSide(color: colors.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static TextButtonThemeData _textButtonTheme({
    required final ColorScheme colors,
    required final TextStyle textStyle,
  }) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: textStyle,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme(
          {required final ColorScheme colors}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colors.brightness == Brightness.light
            ? AppColors.lightGrey.withOpacity(0.5)
            : AppColors.darkSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        hintStyle: TextStyle(color: colors.onSurfaceVariant),
      );

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
          {required final ColorScheme colors}) =>
      BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceVariant,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
      );

  static NavigationBarThemeData _navigationBarTheme(
          {required final ColorScheme colors}) =>
      NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        labelTextStyle:
            WidgetStateProperty.resolveWith((final states) => TextStyle(
                  color: states.contains(WidgetState.selected)
                      ? colors.primary
                      : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                )),
      );

  static ChipThemeData _chipTheme({
    required final ColorScheme colors,
    required final TextTheme textTheme,
  }) =>
      ChipThemeData(
        backgroundColor: colors.surfaceContainerHighest,
        selectedColor: colors.primary,
        disabledColor: colors.onSurface.withOpacity(0.08),
        labelStyle: textTheme.labelLarge?.copyWith(color: colors.onSurface),
        secondaryLabelStyle:
            textTheme.labelLarge?.copyWith(color: colors.onPrimary),
        side: BorderSide(color: colors.outline.withOpacity(0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );

  static TabBarThemeData _tabBarTheme({
    required final ColorScheme colors,
    required final TextTheme textTheme,
  }) =>
      TabBarThemeData(
        labelColor: colors.primary,
        unselectedLabelColor: colors.onSurfaceVariant,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        unselectedLabelStyle: textTheme.labelLarge,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      );

  static FloatingActionButtonThemeData _fabTheme(
          {required final ColorScheme colors}) =>
      FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  static SnackBarThemeData _snackBarTheme({
    required final ColorScheme colors,
    required final TextTheme textTheme,
  }) =>
      SnackBarThemeData(
        backgroundColor: colors.brightness == Brightness.light
            ? AppColors.textPrimary
            : AppColors.darkCard,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
}
