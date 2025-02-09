import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xFF8B4513); // Saddle Brown (Kahverengi)
  static const Color secondary = Color(0xFFD2B48C); // Tan (Bej)
  static const Color background = Color(0xFFF5F5DC); // Beige (Krem)
  static const Color surface = Color(0xFFFFFFFF); // Beyaz
  static const Color accent = Color(0xFFDEB887); // Burlywood (Açık Kahverengi)
  static const Color darkSurface = Color(0xFF3E2723); // Koyu Kahverengi
  static const Color darkBackground = Color(0xFF3C3F41); // Koyu Gri
}

mixin AppTextStyles {
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

mixin AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          onError: Colors.white,
        ),
        appBarTheme: _appBarTheme(AppColors.primary),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.accent,
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
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
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

  static AppBarTheme _appBarTheme(final Color backgroundColor) => AppBarTheme(
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
