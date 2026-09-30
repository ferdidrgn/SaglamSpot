import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Cihaz/platform bazlı performans anahtarları.
abstract final class AppPerformance {
  /// [BackdropFilter] arkasındaki her şeyi her karede yeniden bulanıklaştırır;
  /// kaydırılan bir listenin üstünde (alt nav, yüzen butonlar, cam kartlar)
  /// düşük/orta segment Android GPU'larında karelerin düşmesinin başlıca
  /// nedeniydi. iOS (Impeller/Metal) ve web/masaüstü bunu rahat kaldırıyor;
  /// Android native'de blur kapalı, yerine daha opak bir tint kullanılır.
  static bool get allowBackdropBlur =>
      kIsWeb || defaultTargetPlatform != TargetPlatform.android;
}

/// [BackdropFilter]'ın platforma duyarlı hali: blur izinli değilse
/// [child]'ı doğrudan döndürür (çağıran taraf opak/yarı opak dolguyu
/// kendisi veriyor olmalı — bkz. [AppPerformance.allowBackdropBlur]).
class AdaptiveBackdropBlur extends StatelessWidget {
  const AdaptiveBackdropBlur({
    super.key,
    required this.sigma,
    required this.child,
  });

  final double sigma;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (!AppPerformance.allowBackdropBlur) return child;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: child,
    );
  }
}
