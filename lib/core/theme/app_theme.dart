import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2); // Modern Mavi
  static const Color secondary = Color(0xFFD6E9F9); // Açık Mavi
  static const Color background = Color(0xFFF8F9FA); // Açık Gri
  static const Color surface = Colors.white;
  static const Color darkSurface = Color(0xFF2C3E50); // Koyu Mavi
  static const Color darkBackground = Color(0xFF34495E); // Koyu Gri
  static const Color accent = Color(0xFFe67e22); // Turuncu
}

class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle baseLight = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black87,
  );

  static const TextStyle baseDark = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
  );

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: baseLight.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    displayMedium: baseLight.copyWith(fontSize: 24.0, fontWeight: FontWeight.w500),
    bodyLarge: baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
    labelLarge: baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: baseDark.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    displayMedium: baseDark.copyWith(fontSize: 24.0, fontWeight: FontWeight.w500),
    bodyLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
    labelLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
  );
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
          onError: Colors.white,
        ),
        appBarTheme: _appBarTheme(AppColors.primary),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: AppTextStyles.lightTextTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.brown,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          background: AppColors.darkBackground,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
        ),
        appBarTheme: _appBarTheme(AppColors.primary),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.white70,
        ),
        textTheme: AppTextStyles.darkTextTheme,
      );

  static AppBarTheme _appBarTheme(Color backgroundColor) => AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        backgroundColor: backgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      );
}