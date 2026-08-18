import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_design_tokens.dart';

/// Sayfanın en arkasında oturan, yavaşça "nefes alan" bir gradyan-mesh +
/// gren dokusu. Dokunuşları asla yakalamaz ([IgnorePointer]); tek işi
/// endüstriyel-cam yüzeylerin arkasında hafif bir ambiyans ışığı ve doku
/// sağlamak. Renkleri [AppGlassTokens.meshColors]'tan gelir, bu yüzden
/// açık/koyu temada otomatik doğru tonu alır.
///
/// Hareket, 3 lekenin konumunu 24 saniyelik yavaş bir döngüde kaydıran tek
/// bir [AnimationController] ile sürülür — CPU/GPU maliyeti düşük tutmak
/// için gren dokusu yalnızca BİR KEZ, sabit bir tohumla (seed) çizilir ve
/// `shouldRepaint` her zaman false döner.
class AmbientMeshBackground extends StatefulWidget {
  const AmbientMeshBackground({super.key, this.animate = true});

  final bool animate;

  @override
  State<AmbientMeshBackground> createState() => _AmbientMeshBackgroundState();
}

class _AmbientMeshBackgroundState extends State<AmbientMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final tokens = context.glass;
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (final context, final _) => CustomPaint(
                painter: _MeshPainter(
                  progress: _controller.value,
                  colors: tokens.meshColors,
                ),
              ),
            ),
            RepaintBoundary(
              child: CustomPaint(
                painter: _NoisePainter(opacity: tokens.noiseOpacity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  const _MeshPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(final Canvas canvas, final Size size) {
    final t = progress * 2 * math.pi;
    final blobs = <Offset>[
      Offset(size.width * (0.15 + 0.05 * math.sin(t)), size.height * (0.12 + 0.04 * math.cos(t))),
      Offset(size.width * (0.85 + 0.04 * math.cos(t * 0.8)), size.height * (0.28 + 0.05 * math.sin(t * 0.8))),
      Offset(size.width * (0.5 + 0.06 * math.sin(t * 0.6)), size.height * (0.85 + 0.04 * math.cos(t * 0.6))),
    ];
    final radii = [size.shortestSide * 0.55, size.shortestSide * 0.5, size.shortestSide * 0.6];

    for (var i = 0; i < blobs.length && i < colors.length; i++) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [colors[i], colors[i].withOpacity(0)],
        ).createShader(Rect.fromCircle(center: blobs[i], radius: radii[i]))
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(blobs[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant final _MeshPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.colors != colors;
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({required this.opacity});

  final double opacity;
  static final math.Random _rng = math.Random(7);
  static const int _dotCount = 220;

  @override
  void paint(final Canvas canvas, final Size size) {
    if (opacity <= 0) return;
    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    for (var i = 0; i < _dotCount; i++) {
      final dx = _rng.nextDouble() * size.width;
      final dy = _rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant final _NoisePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
