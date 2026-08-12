import 'package:shared_preferences/shared_preferences.dart';

/// Bu cihazda en son bir yöneticinin giriş yapıp yapmadığını hatırlar.
/// Amaç: yönetici uygulamayı her açtığında müşteri vitrinini değil,
/// doğrudan kendi panelini görsün — ama istediğinde müşteri sayfalarına
/// da serbestçe geçebilsin (bkz. app_router.dart tek seferlik yönlendirme).
///
/// `load()` main.dart'ta runApp'ten ÖNCE, senkron okunabilmesi için
/// belleğe alınır — router'ın redirect callback'i async olmadan bu
/// değeri okuyabilsin diye.
final class AdminSessionCache {
  AdminSessionCache._();

  static const String _key = 'was_admin_logged_in';
  static bool _wasAdminLoggedIn = false;

  static bool get wasAdminLoggedIn => _wasAdminLoggedIn;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _wasAdminLoggedIn = prefs.getBool(_key) ?? false;
  }

  static Future<void> setAdminLoggedIn(final bool value) async {
    _wasAdminLoggedIn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
