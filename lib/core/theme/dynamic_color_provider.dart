import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dynamic_color_cache.dart';

/// Kullanıcının "telefonumun temasını kullan" tercihi — theme_mode_provider.dart
/// ile aynı desen: cihazda kalıcı, Settings sayfasından değiştirilir.
class DynamicColorNotifier extends Notifier<bool> {
  @override
  bool build() => DynamicColorCache.saved;

  void set(final bool enabled) {
    state = enabled;
    DynamicColorCache.setSaved(enabled);
  }
}

final dynamicColorEnabledProvider =
    NotifierProvider<DynamicColorNotifier, bool>(DynamicColorNotifier.new);
