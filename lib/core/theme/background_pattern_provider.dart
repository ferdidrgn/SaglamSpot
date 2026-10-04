import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mobil ekranların arka plan dokusu — Ayarlar > Görünüm'den seçilir.
/// Hepsi aynı marka zeminine çizilen, çok düşük opaklıkta statik
/// desenlerdir (bkz. AtelierBackground); performans maliyeti tek seferlik
/// bir boyamadır.
enum BackgroundPattern {
  /// Düz zemin — desen yok.
  plain,

  /// Ahşap damarı: hafif dalgalı yatay lif çizgileri.
  wood,

  /// Mezura: kenarda cetvel çentikleri + seyrek ölçü ızgarası.
  tape,

  /// Keten: ince çapraz dokuma.
  linen,
}

final class BackgroundPatternCache {
  BackgroundPatternCache._();

  static const String _key = 'app_background_pattern';
  static BackgroundPattern _saved = BackgroundPattern.wood;

  static BackgroundPattern get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    _saved = BackgroundPattern.values.firstWhere(
      (final p) => p.name == name,
      orElse: () => BackgroundPattern.wood,
    );
  }

  static Future<void> setSaved(final BackgroundPattern value) async {
    _saved = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value.name);
  }
}

class BackgroundPatternNotifier extends Notifier<BackgroundPattern> {
  @override
  BackgroundPattern build() => BackgroundPatternCache.saved;

  void set(final BackgroundPattern value) {
    state = value;
    BackgroundPatternCache.setSaved(value);
  }
}

final backgroundPatternProvider =
    NotifierProvider<BackgroundPatternNotifier, BackgroundPattern>(
        BackgroundPatternNotifier.new);
