import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color palette for a warm, wooden furniture theme
  static const Color primaryColor = Color(0xFF8B5A2B); // SaddleBrown
  static const Color secondaryColor = Color(0xFFD2B48C); // Tan
  static const Color backgroundColor = Color(0xFFF5F5DC); // Beige
  static const Color surfaceColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFFD2B48C), // Tan
      unselectedItemColor: Colors.white70,
    ),
    textTheme: _darkTextTheme,
  );

  static const TextStyle _baseLightTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.black87,
  );

  static const TextStyle _baseDarkTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Roboto', fontSize: 96.0, fontWeight: FontWeight.w300, color: Colors.black87),
    displayMedium: TextStyle(fontFamily: 'Roboto', fontSize: 60.0, fontWeight: FontWeight.w300, color: Colors.black87),
    displaySmall: TextStyle(fontFamily: 'Roboto', fontSize: 48.0, fontWeight: FontWeight.w400, color: Colors.black87),
    headlineLarge: _baseLightTextStyle.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: _baseLightTextStyle.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: _baseLightTextStyle.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: _baseLightTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    titleMedium: _baseLightTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    titleSmall: _baseLightTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    bodyLarge: _baseLightTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyMedium: _baseLightTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400),
    bodySmall: _baseLightTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    labelLarge: _baseLightTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: _baseLightTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    labelSmall: _baseLightTextStyle.copyWith(fontSize: 11.0, fontWeight: FontWeight.w400),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _baseDarkTextStyle.copyWith(fontSize: 96.0, fontWeight: FontWeight.w300),
    displayMedium: _baseDarkTextStyle.copyWith(fontSize: 60.0, fontWeight: FontWeight.w300),
    displaySmall: _baseDarkTextStyle.copyWith(fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineLarge: _baseDarkTextStyle.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
    headlineMedium: _baseDarkTextStyle.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
    headlineSmall: _baseDarkTextStyle.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
    titleLarge: _baseDarkTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    titleMedium: _baseDarkTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    titleSmall: _baseDarkTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    bodyLarge: _baseDarkTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyMedium: _baseDarkTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400),
    bodySmall: _baseDarkTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    labelLarge: _baseDarkTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: _baseDarkTextStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
    labelSmall: _baseDarkTextStyle.copyWith(fontSize: 11.0, fontWeight: FontWeight.w400),
  );
}

List<Color> gradientColors(BuildContext context, bool isTrue) {
  final brightness = Theme.of(context).brightness;
  return isTrue
      ? (brightness == Brightness.light
          ? [AppTheme.primaryColor.withOpacity(0.7), AppTheme.primaryColor]
          : [AppTheme.secondaryColor.withOpacity(0.7), AppTheme.secondaryColor])
      : [Colors.grey[500]!, Colors.grey[800]!];
}

List<Color> gradientOpacityColors() {
  return [Colors.transparent, Colors.black.withOpacity(0.3)];
} 