import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Mobilya teması için renkler
  static const _primaryColor = Color(AppConstants.primaryColor); // Kahverengi
  static const _secondaryColor = Color(AppConstants.secondaryColor); // Açık kahve

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      primaryContainer: _primaryColor.withOpacity(0.8),
      secondary: _secondaryColor,
      secondaryContainer: _secondaryColor.withOpacity(0.8),
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: Colors.red[700]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      backgroundColor: _primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: _primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _primaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey[600],
    ),
    textTheme: _lightTextTheme,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      primaryContainer: _primaryColor.withOpacity(0.7),
      secondary: _secondaryColor,
      secondaryContainer: _secondaryColor.withOpacity(0.7),
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: Colors.red[700]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      backgroundColor: _primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: _primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: _secondaryColor,
      unselectedItemColor: Colors.white70,
    ),
    textTheme: _darkTextTheme,
  );

  static const _baseLightTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.black87,
  );

  static const _baseDarkTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
  );

  static final _lightTextTheme = TextTheme(
    displayLarge: _baseLightTextStyle.copyWith(
        fontSize: 96.0, fontWeight: FontWeight.w300),
    displayMedium: _baseLightTextStyle.copyWith(
        fontSize: 60.0, fontWeight: FontWeight.w300),
    displaySmall: _baseLightTextStyle.copyWith(
        fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineLarge: _baseLightTextStyle.copyWith(
        fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: _baseLightTextStyle.copyWith(
        fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: _baseLightTextStyle.copyWith(
        fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: _baseLightTextStyle.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    titleMedium: _baseLightTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    titleSmall: _baseLightTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    bodyLarge: _baseLightTextStyle.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyMedium: _baseLightTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w400),
    bodySmall: _baseLightTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    labelLarge: _baseLightTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: _baseLightTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    labelSmall: _baseLightTextStyle.copyWith(
        fontSize: 11.0, fontWeight: FontWeight.w400),
  );

  static final _darkTextTheme = TextTheme(
    displayLarge: _baseDarkTextStyle.copyWith(
        fontSize: 96.0, fontWeight: FontWeight.w300),
    displayMedium: _baseDarkTextStyle.copyWith(
        fontSize: 60.0, fontWeight: FontWeight.w300),
    displaySmall: _baseDarkTextStyle.copyWith(
        fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineLarge: _baseDarkTextStyle.copyWith(
        fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: _baseDarkTextStyle.copyWith(
        fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: _baseDarkTextStyle.copyWith(
        fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: _baseDarkTextStyle.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    titleMedium: _baseDarkTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    titleSmall: _baseDarkTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    bodyLarge: _baseDarkTextStyle.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyMedium: _baseDarkTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w400),
    bodySmall: _baseDarkTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    labelLarge: _baseDarkTextStyle.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: _baseDarkTextStyle.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    labelSmall: _baseDarkTextStyle.copyWith(
        fontSize: 11.0, fontWeight: FontWeight.w400),
  );
}

List<Color> gradientColors(BuildContext context, bool isTrue) {
  return isTrue
      ? (Theme.of(context).brightness == Brightness.light
      ? [
    const Color(AppConstants.primaryColor).withOpacity(0.7),
    const Color(AppConstants.primaryColor)
  ]
      : [
    const Color(AppConstants.secondaryColor).withOpacity(0.7),
    const Color(AppConstants.secondaryColor)
  ])
      : [Colors.grey[500]!, Colors.grey[800]!];
}

List<Color> gradientOpacityColors() {
  return [Colors.transparent, Colors.black.withOpacity(0.3)];
} 