import 'package:flutter/material.dart';

mixin AppTextStyles {
  static const String fontFamily = 'Inter'; // Modern font

  // Modern renklerle güncellenmiş text stilleri
  static const TextStyle baseLight = TextStyle(
    fontFamily: fontFamily,
    color: Color(0xFF1E293B), // Modern dark gray
    fontWeight: FontWeight.w400,
  );

  static const TextStyle baseDark = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: baseLight.copyWith(
      fontSize: 57.0,
      fontWeight: FontWeight.w700,
      height: 1.12,
    ),
    displayMedium: baseLight.copyWith(
      fontSize: 45.0,
      fontWeight: FontWeight.w600,
      height: 1.15,
    ),
    displaySmall: baseLight.copyWith(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      height: 1.22,
    ),
    headlineLarge: baseLight.copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    headlineMedium: baseLight.copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.w500,
      height: 1.28,
    ),
    headlineSmall: baseLight.copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      height: 1.33,
    ),
    titleLarge: baseLight.copyWith(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      height: 1.27,
    ),
    titleMedium: baseLight.copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    titleSmall: baseLight.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    bodyLarge: baseLight.copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.5,
    ),
    bodyMedium: baseLight.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    bodySmall: baseLight.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
    ),
    labelLarge: baseLight.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    labelMedium: baseLight.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.33,
      letterSpacing: 0.5,
    ),
    labelSmall: baseLight.copyWith(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.5,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: baseDark.copyWith(
      fontSize: 57.0,
      fontWeight: FontWeight.w700,
      height: 1.12,
    ),
    displayMedium: baseDark.copyWith(
      fontSize: 45.0,
      fontWeight: FontWeight.w600,
      height: 1.15,
    ),
    displaySmall: baseDark.copyWith(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      height: 1.22,
    ),
    headlineLarge: baseDark.copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    headlineMedium: baseDark.copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.w500,
      height: 1.28,
    ),
    headlineSmall: baseDark.copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      height: 1.33,
    ),
    titleLarge: baseDark.copyWith(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      height: 1.27,
    ),
    titleMedium: baseDark.copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    titleSmall: baseDark.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    bodyLarge: baseDark.copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.5,
    ),
    bodyMedium: baseDark.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    bodySmall: baseDark.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
    ),
    labelLarge: baseDark.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    labelMedium: baseDark.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.33,
      letterSpacing: 0.5,
    ),
    labelSmall: baseDark.copyWith(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.5,
    ),
  );
}
