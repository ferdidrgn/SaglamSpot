import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Defines the color palette for the app.
class AppColors {
  static const Color primary = Color(0xFF8B5A2B); // SaddleBrown
  static const Color secondary = Color(0xFFD2B48C); // Tan
  static const Color background = Color(0xFFF5F5DC); // Beige
  static const Color surface = Colors.white;
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
}

/// Defines the text styles for the app.
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
    displayLarge: baseLight.copyWith(fontSize: 96.0, fontWeight: FontWeight.w300),
    displayMedium: baseLight.copyWith(fontSize: 60.0, fontWeight: FontWeight.w300),
    displaySmall: baseLight.copyWith(fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineLarge: baseLight.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: baseLight.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: baseLight.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyLarge: baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    labelLarge: baseLight.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: baseDark.copyWith(fontSize: 96.0, fontWeight: FontWeight.w300),
    displayMedium: baseDark.copyWith(fontSize: 60.0, fontWeight: FontWeight.w300),
    displaySmall: baseDark.copyWith(fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineLarge: baseDark.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: baseDark.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: baseDark.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    labelLarge: baseDark.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  );
}

/// Defines the theme configuration for the app.
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

  /// Utility methods for gradient colors.
  static List<Color> gradientColors(BuildContext context, bool isConditionMet) {
    final brightness = Theme.of(context).brightness;
    return isConditionMet
        ? (brightness == Brightness.light
            ? [AppColors.primary.withOpacity(0.7), AppColors.primary]
            : [AppColors.secondary.withOpacity(0.7), AppColors.secondary])
        : [Colors.grey[500]!, Colors.grey[800]!];
  }

  static List<Color> gradientOpacityColors() {
    return [Colors.transparent, Colors.black.withOpacity(0.3)];
  }
}
