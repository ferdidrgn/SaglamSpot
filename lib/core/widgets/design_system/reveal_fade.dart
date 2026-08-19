import 'package:flutter/material.dart';

/// Sayfa ilk açıldığında içeriği kademeli olarak (fade + hafif yukarı kayma)
/// belirten, controller/dispose gerektirmeyen tek seferlik giriş animasyonu.
/// [delayMs] farklı elemanlar için farklı verilerek bir "cascade" (art
/// arda beliren) his yaratılır — [TweenAnimationBuilder] tek başına gecikme
/// desteklemediği için, toplam süre içindeki başlangıç oranı hesaplanıp
/// eğri buna göre yeniden ölçekleniyor.
class RevealFade extends StatelessWidget {
  const RevealFade({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.durationMs = 480,
    this.offsetY = 14,
  });

  final Widget child;
  final int delayMs;
  final int durationMs;
  final double offsetY;

  @override
  Widget build(final BuildContext context) {
    final total = delayMs + durationMs;
    final startFraction = total == 0 ? 0.0 : delayMs / total;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Curves.easeOutCubic,
      builder: (final context, final t, final child) {
        final raw =
            startFraction >= 1 ? 0.0 : ((t - startFraction) / (1 - startFraction)).clamp(0.0, 1.0);
        return Opacity(
          opacity: raw,
          child: Transform.translate(offset: Offset(0, (1 - raw) * offsetY), child: child),
        );
      },
      child: child,
    );
  }
}
