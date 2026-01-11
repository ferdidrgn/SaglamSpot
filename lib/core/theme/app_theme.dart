import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

mixin AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryLight,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondaryLight,
          onSecondaryContainer: AppColors.secondaryDark,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          onSurfaceVariant: AppColors.textSecondary,
          background: AppColors.background,
          onBackground: AppColors.textPrimary,
          error: AppColors.error,
          onError: Colors.white,
          // Material 3 yeni yüzey renkleri
          surfaceContainerHighest: AppColors.surface,
          outline: AppColors.border,
          shadow: Colors.black12,
        ),
        appBarTheme: _appBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            brightness: Brightness.light),
        cardTheme: _cardTheme(),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        textButtonTheme: _textButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        bottomNavigationBarTheme: _bottomNavigationBarTheme(),
        navigationBarTheme: _navigationBarTheme(),
        textTheme: AppTextStyles.lightTextTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryDark,
          onPrimaryContainer: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondaryDark,
          onSecondaryContainer: Colors.white,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceVariant: AppColors.darkCard,
          onSurfaceVariant: AppColors.darkTextSecondary,
          background: AppColors.darkBackground,
          onBackground: AppColors.darkTextPrimary,
          error: AppColors.error,
          onError: Colors.white,
          outline: AppColors.darkBorder,
          shadow: Colors.black26,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: _appBarTheme(
            backgroundColor: AppColors.darkSurface,
            foregroundColor: AppColors.darkTextPrimary,
            brightness: Brightness.dark),
        cardTheme: _cardTheme(),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        textButtonTheme: _textButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        bottomNavigationBarTheme: _bottomNavigationBarTheme(),
        navigationBarTheme: _navigationBarTheme(),
        textTheme: AppTextStyles.darkTextTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static AppBarTheme _appBarTheme({
    required final Color backgroundColor,
    required final Color foregroundColor,
    required final Brightness brightness,
  }) =>
      AppBarTheme(
        centerTitle: false,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        // M3'te yukarı kaydırınca renk değişimini yönetir
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: brightness == Brightness.light ? Colors.black : Colors.white,
            size: 30),
        titleTextStyle: AppTextStyles.lightTextTheme.titleLarge?.copyWith(
            color: brightness == Brightness.light ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        //systemOverlayStyle: SystemUiOverlayStyle.light,
      );

  static CardThemeData _cardTheme() => const CardThemeData(
        elevation: 2,
        color: AppColors.surface,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: EdgeInsets.zero,
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          // Ana CTA rengi
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: AppColors.accent),
          // Bakır çerçeve          shape:
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.lightTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme() =>
      const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textTertiary),
      );

  static BottomNavigationBarThemeData _bottomNavigationBarTheme() =>
      const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
      );

  static NavigationBarThemeData _navigationBarTheme() => NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.resolveWith((final states) {
          if (states.contains(MaterialState.selected))
            return AppTextStyles.lightTextTheme.labelLarge
                ?.copyWith(color: AppColors.primary);
          return AppTextStyles.lightTextTheme.labelLarge
              ?.copyWith(color: AppColors.textTertiary);
        }),
      );
}
