import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_design_tokens.dart';

/// Sayfanın en arkasında oturan endüstriyel ambiyans katmanı: bir
/// "blueprint" ızgara dokusu + yavaşça nefes alan gradyan-mesh lekeleri +
/// ince bir gren dokusu. Dokunuşları asla yakalamaz ([IgnorePointer]); tek
/// işi arkadaki cam yüzeylere gerçek bir ışık/doku kaynağı sağlamak.
/// Renkleri [AppGlassTokens]'tan gelir, bu yüzden açık/koyu temada
/// otomatik doğru tonu alır.
///
/// Hareket, 3 lekenin konumunu 24 saniyelik yavaş bir döngüde kaydıran tek
/// bir [AnimationController] ile sürülür. Izgara ve gren dokusu SADECE BİR
/// KEZ çizilir (`shouldRepaint` sabit false) — animasyon sadece mesh
/// katmanını etkiler, CPU/GPU maliyeti düşük kalır.
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
    final grainColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: CustomPaint(painter: _GridPainter(color: tokens.gridLineColor)),
            ),
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
                painter: _NoisePainter(opacity: tokens.noiseOpacity, color: grainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Endüstriyel "blueprint" ızgarası — 48px ana hatlar + 12px ince alt
/// bölüm çizgileri. Sabit bir desen olduğu için tek seferlik çizilir.
class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;

  static const double _minorStep = 24;
  static const int _majorEvery = 4;

  @override
  void paint(final Canvas canvas, final Size size) {
    final minorPaint = Paint()
      ..color = color.withOpacity(color.opacity * 0.45)
      ..strokeWidth = 0.6;
    final majorPaint = Paint()
      ..color = color
      ..strokeWidth = 0.8;

    var i = 0;
    for (double x = 0; x <= size.width; x += _minorStep, i++) {
      final paint = i % _majorEvery == 0 ? majorPaint : minorPaint;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    i = 0;
    for (double y = 0; y <= size.height; y += _minorStep, i++) {
      final paint = i % _majorEvery == 0 ? majorPaint : minorPaint;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant final _GridPainter oldDelegate) => oldDelegate.color != color;
}

class _MeshPainter extends CustomPainter {
  const _MeshPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(final Canvas canvas, final Size size) {
    final t = progress * 2 * math.pi;
    final blobs = <Offset>[
      Offset(size.width * (0.15 + 0.06 * math.sin(t)), size.height * (0.12 + 0.05 * math.cos(t))),
      Offset(size.width * (0.85 + 0.05 * math.cos(t * 0.8)), size.height * (0.3 + 0.06 * math.sin(t * 0.8))),
      Offset(size.width * (0.5 + 0.07 * math.sin(t * 0.6)), size.height * (0.85 + 0.05 * math.cos(t * 0.6))),
    ];
    final radii = [size.shortestSide * 0.6, size.shortestSide * 0.55, size.shortestSide * 0.65];

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
  _NoisePainter({required this.opacity, required this.color});

  final double opacity;
  final Color color;
  static const int _dotCount = 420;

  @override
  void paint(final Canvas canvas, final Size size) {
    if (opacity <= 0) return;
    // Her paint çağrısında SABİT tohumla yeniden başlatılıyor — desen,
    // kaç kez çizilirse çizilsin aynı kalır (kaymaz/titremez).
    final rng = math.Random(7);
    final paint = Paint()..color = color.withOpacity(opacity);
    for (var i = 0; i < _dotCount; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant final _NoisePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.color != color;
}
