import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_mode_cache.dart';

/// Görünüm tercihi (Açık / Sistem / Koyu) — Settings sayfasından
/// değiştirilir, cihazda kalıcı olarak saklanır (bkz. ThemeModeCache).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => _fromKey(ThemeModeCache.saved);

  void set(final ThemeMode mode) {
    state = mode;
    ThemeModeCache.setSaved(_toKey(mode));
  }

  static ThemeMode _fromKey(final String key) {
    switch (key) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  static String _toKey(final ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
