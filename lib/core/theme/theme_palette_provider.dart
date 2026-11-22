import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renk paleti uygulamanın mevcut açık/koyu modundan bağımsız seçilir.
enum ThemePalette { atelier, lavender, midnight }

final class ThemePaletteCache {
  ThemePaletteCache._();

  static const String _key = 'app_theme_palette';
  static ThemePalette _saved = ThemePalette.atelier;

  static ThemePalette get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    _saved = ThemePalette.values.firstWhere(
      (final palette) => palette.name == name,
      orElse: () => ThemePalette.atelier,
    );
  }

  static Future<void> setSaved(final ThemePalette palette) async {
    _saved = palette;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, palette.name);
  }
}

class ThemePaletteNotifier extends Notifier<ThemePalette> {
  @override
  ThemePalette build() => ThemePaletteCache.saved;

  Future<void> set(final ThemePalette palette) async {
    state = palette;
    await ThemePaletteCache.setSaved(palette);
  }
}

final themePaletteProvider =
    NotifierProvider<ThemePaletteNotifier, ThemePalette>(
  ThemePaletteNotifier.new,
);
