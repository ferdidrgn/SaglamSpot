import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Sürekli çalışan (repeat()) animasyonları, ekranda görünmedikleri sürece
/// durdurur: alt ağaçtaki tüm AnimationController/Ticker'lar [TickerMode]
/// ile susturulur. Kaydırılıp görünmez olan bir marquee ya da dekoratif
/// katman artık kare üretip GPU/pil harcamaz. Ayrıca her karede yeniden
/// boyanan içeriği [RepaintBoundary] ile sayfanın geri kalanından izole
/// eder.
class PauseWhenOffscreen extends StatefulWidget {
  const PauseWhenOffscreen({super.key, required this.child});

  final Widget child;

  @override
  State<PauseWhenOffscreen> createState() => _PauseWhenOffscreenState();
}

class _PauseWhenOffscreenState extends State<PauseWhenOffscreen> {
  late final Key _detectorKey = UniqueKey();
  bool _visible = true;

  @override
  Widget build(final BuildContext context) => VisibilityDetector(
        key: _detectorKey,
        onVisibilityChanged: (final info) {
          final visible = info.visibleFraction > 0;
          if (mounted && visible != _visible) {
            setState(() => _visible = visible);
          }
        },
        child: TickerMode(
          enabled: _visible,
          child: RepaintBoundary(child: widget.child),
        ),
      );
}
