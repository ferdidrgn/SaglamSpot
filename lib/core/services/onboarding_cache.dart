import 'package:shared_preferences/shared_preferences.dart';

/// Bu cihazda "ev içi tanıtım" (onboarding) akışının daha önce gösterilip
/// gösterilmediğini hatırlar. `load()` main.dart'ta runApp'ten ÖNCE,
/// senkron okunabilmesi için belleğe alınır — router'ın ilk konum kararını
/// async olmadan bu değere göre verebilsin diye (bkz. AdminSessionCache /
/// ThemeModeCache — aynı kurulan desen).
final class OnboardingCache {
  OnboardingCache._();

  static const String _key = 'has_seen_onboarding';
  static bool _hasSeenOnboarding = false;

  static bool get hasSeenOnboarding => _hasSeenOnboarding;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool(_key) ?? false;
  }

  static Future<void> markSeen() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
