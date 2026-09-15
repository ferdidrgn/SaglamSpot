import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının "telefonumun temasını kullan" (Android Material You / dinamik
/// renk) tercihini kalıcı olarak saklar. Varsayılan KAPALI — kullanıcı
/// bilerek açana kadar uygulama kendi sabit marka paletini (zümrüt/altın)
/// kullanmaya devam eder.
final class DynamicColorCache {
  DynamicColorCache._();

  static const String _key = 'app_use_dynamic_color';
  static bool _saved = false;

  static bool get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _saved = prefs.getBool(_key) ?? false;
  }

  static Future<void> setSaved(final bool value) async {
    _saved = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
