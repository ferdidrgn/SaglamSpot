import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLogo { luxe, illustrated }

final class AppLogoCache {
  AppLogoCache._();

  static const String _key = 'app_logo';
  static AppLogo _saved = AppLogo.luxe;

  static AppLogo get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    _saved = AppLogo.values.firstWhere(
      (final logo) => logo.name == name,
      orElse: () => AppLogo.luxe,
    );
  }

  static Future<void> setSaved(final AppLogo logo) async {
    await const MethodChannel('com.saglamspot/app_icon')
        .invokeMethod<void>('setAppLogo', logo.name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, logo.name);
    _saved = logo;
  }
}

class AppLogoNotifier extends Notifier<AppLogo> {
  @override
  AppLogo build() => AppLogoCache.saved;

  Future<void> set(final AppLogo logo) async {
    await AppLogoCache.setSaved(logo);
    state = logo;
  }
}

final appLogoProvider = NotifierProvider<AppLogoNotifier, AppLogo>(
  AppLogoNotifier.new,
);
