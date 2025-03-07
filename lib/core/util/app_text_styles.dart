import 'package:flutter/material.dart';

mixin AppTextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle baseLight =
      TextStyle(fontFamily: fontFamily, color: Colors.black87);

  static const TextStyle baseDark =
      TextStyle(fontFamily: fontFamily, color: Colors.white);

  static TextTheme lightTextTheme = TextTheme(
    displayLarge:
        baseLight.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    displayMedium:
        baseLight.copyWith(fontSize: 24.0, fontWeight: FontWeight.w500),
    bodyLarge:
        baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
    labelLarge: baseLight.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge:
        baseDark.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
    displayMedium:
        baseDark.copyWith(fontSize: 24.0, fontWeight: FontWeight.w500),
    bodyLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
    labelLarge: baseDark.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
  );
}
