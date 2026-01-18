import 'package:flutter/material.dart';
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
          // Dark Mint
          secondary: AppColors.accent,
          // Gold
          surface: AppColors.background,
          onPrimary: AppColors.white,
          onSecondary: AppColors.primary,
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
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.backgroundDark,
          background: AppColors.backgroundDark,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.white,
          onBackground: AppColors.white,
          onError: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkGrey,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: AppTextStyles.subtitle1,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
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
}
