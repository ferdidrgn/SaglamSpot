import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının görünüm (açık/koyu/sistem) tercihini kalıcı olarak saklar.
/// `load()` main.dart'ta runApp'ten ÖNCE çağrılır — ilk karede yanlış
/// temanın bir an görünüp sonra değişmesini (flash) önlemek için.
final class ThemeModeCache {
  ThemeModeCache._();

  static const String _key = 'app_theme_mode';
  static String _saved = 'light';

  /// 'light' | 'dark' | 'system'
  static String get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _saved = prefs.getString(_key) ?? 'light';
  }

  static Future<void> setSaved(final String value) async {
    _saved = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }
}
