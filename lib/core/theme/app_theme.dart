import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// Riverpod ile tema yönetimini sağlarız
final appThemeProvider = Provider<AppTheme>((final ref) {
  return AppTheme();
});

class AppTheme {
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryVariant,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryVariant,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.textSecondary,
          error: AppColors.error,
          onError: AppColors.onError,
          // Material 3 yeni yüzey renkleri
          surfaceContainerHighest: AppColors.surface,
          outline: AppColors.border,
          shadow: Colors.black12,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          bodyLarge: AppTextStyles.bodyText1,
        ),
        // AppBar ayarı
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkSurface,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryVariant,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryVariant,
          surface: AppColors.darkSurface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
          surfaceContainerHighest: AppColors.surface,
          outline: AppColors.border,
          shadow: Colors.white12,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: _appBarTheme(
            colors: colors, textTheme: coloredTextTheme, bgColor: bgColor),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.h1.copyWith(color: AppColors.white),
          displayMedium: AppTextStyles.h2.copyWith(color: AppColors.white),
          displaySmall: AppTextStyles.h3.copyWith(color: AppColors.white),
          headlineMedium:
              AppTextStyles.subtitle1.copyWith(color: AppColors.white),
          headlineSmall:
              AppTextStyles.subtitle2.copyWith(color: AppColors.white),
          bodyLarge: AppTextStyles.bodyText1.copyWith(color: AppColors.white),
          bodyMedium: AppTextStyles.bodyText2.copyWith(color: AppColors.white),
          bodySmall: AppTextStyles.caption.copyWith(color: AppColors.white),
          labelLarge: AppTextStyles.button.copyWith(color: AppColors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            textStyle: AppTextStyles.button,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Dark tema için input dekorasyonları
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.mediumGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.mediumGrey),
          ),
          labelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.white),
          hintStyle:
              AppTextStyles.bodyText2.copyWith(color: AppColors.mediumGrey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  static AppBarTheme _appBarTheme({
    required final ColorScheme colors,
    required final TextTheme textTheme,
    required final Color bgColor,
  }) =>
      AppBarTheme(
        backgroundColor: bgColor,
        // Atmosferik modda Appbar da renkli olsun
        //backgroundColor: Colors.transparent,
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

  static CardThemeData _cardTheme(
      {required final ColorScheme colors, required final Color bgColor}) {
    // Atmosferik modda kartlar, arka plandan biraz daha açık (aydınlık) olmalı
    final cardColor = HSLColor.fromColor(bgColor)
        .withLightness(
            (HSLColor.fromColor(bgColor).lightness + 0.05).clamp(0.0, 1.0))
        .toColor();
    return CardThemeData(
      // M3'te surfaceContainerHighest önerilir, yoksa surface kullanır
      color: colors.brightness == Brightness.dark
          ? cardColor
          : colors.surfaceContainerHighest,
      elevation: 2,
      shadowColor: colors.shadow.withOpacity(0.35),
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
          side: BorderSide(color: colors.primary), // Outline rengi primary
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
        // Hafif opaklık vererek arka plandan ayırıyoruz
        fillColor: colors.surfaceContainerHighest.withOpacity(0.5),
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
            MaterialStateProperty.resolveWith((final states) => TextStyle(
                  color: states.contains(MaterialState.selected)
                      ? colors.onSecondaryContainer
                      : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                )),
      );
}
