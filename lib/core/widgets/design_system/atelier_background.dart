import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/background_pattern_provider.dart';

/// Mobil ekranların ortak zemini: marka arka plan rengi + kullanıcının
/// Ayarlar'dan seçtiği atölye dokusu (ahşap damarı / mezura / keten / düz)
/// + üstte sıcak bir ışık lekesi. Desen [RepaintBoundary] içinde ve
/// statik — kaydırma sırasında YENİDEN BOYANMAZ, maliyeti tek seferlik.
///
/// Kullanım: `Scaffold(backgroundColor: Colors.transparent, ...)` yerine
/// Scaffold'u bununla sarmak değil, Scaffold'un `body`'sini sarmak:
/// `body: AtelierBackground(child: ...)`.
class AtelierBackground extends ConsumerWidget {
  const AtelierBackground({super.key, required this.child, this.pattern});

  final Widget child;

  /// Verilirse kullanıcı tercihini ezer (ör. Ayarlar'daki önizleme
  /// karelerinde).
  final BackgroundPattern? pattern;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final BackgroundPattern effective =
        pattern ?? ref.watch(backgroundPatternProvider);
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: AtelierPatternPainter(
                pattern: effective,
                base: AppColors.background,
                ink: AppColors.primary,
                glow: AppColors.accent,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class AtelierPatternPainter extends CustomPainter {
  AtelierPatternPainter({
    required this.pattern,
    required this.base,
    required this.ink,
    required this.glow,
  });

  final BackgroundPattern pattern;
  final Color base;
  final Color ink;
  final Color glow;

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    // Üst köşeden sızan sıcak ışık — dükkân vitrinine düşen güneş gibi.
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glow.withValues(alpha: 0.10), glow.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.9, -size.width * 0.1),
          radius: size.width * 0.9));
    canvas.drawRect(Offset.zero & size, glowPaint);

    switch (pattern) {
      case BackgroundPattern.plain:
        return;
      case BackgroundPattern.wood:
        _paintWood(canvas, size);
      case BackgroundPattern.tape:
        _paintTape(canvas, size);
      case BackgroundPattern.linen:
        _paintLinen(canvas, size);
    }
  }

  void _paintWood(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ink.withValues(alpha: 0.045);
    const double gap = 22;
    final rnd = math.Random(7);
    for (double y = 10; y < size.height; y += gap) {
      final path = Path()..moveTo(0, y);
      final amp = 2.5 + rnd.nextDouble() * 4;
      final freq = 0.004 + rnd.nextDouble() * 0.006;
      final phase = rnd.nextDouble() * math.pi * 2;
      for (double x = 0; x <= size.width; x += 12) {
        path.lineTo(x, y + math.sin(x * freq * math.pi + phase) * amp);
      }
      canvas.drawPath(path, paint);
    }
    // Birkaç seyrek "budak" halkası.
    final knot = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ink.withValues(alpha: 0.04);
    for (int i = 0; i < 3; i++) {
      final c = Offset(size.width * (0.15 + rnd.nextDouble() * 0.7),
          size.height * (0.2 + rnd.nextDouble() * 0.7));
      for (int r = 0; r < 4; r++) {
        canvas.drawOval(
            Rect.fromCenter(
                center: c, width: 26.0 + r * 12, height: 10.0 + r * 6),
            knot);
      }
    }
  }

  void _paintTape(final Canvas canvas, final Size size) {
    final grid = Paint()
      ..strokeWidth = 1
      ..color = ink.withValues(alpha: 0.035);
    const double cell = 48;
    for (double x = cell; x < size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = cell; y < size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // Sol kenarda mezura çentikleri: her 8 px kısa, her 40 px uzun.
    final tick = Paint()
      ..strokeWidth = 1
      ..color = ink.withValues(alpha: 0.09);
    for (double y = 0; y < size.height; y += 8) {
      final major = (y % 40) == 0;
      canvas.drawLine(Offset(0, y), Offset(major ? 10 : 5, y), tick);
    }
  }

  void _paintLinen(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = ink.withValues(alpha: 0.03);
    const double step = 9;
    final diag = size.width + size.height;
    for (double d = -size.height; d < diag; d += step) {
      canvas.drawLine(
          Offset(d, 0), Offset(d + size.height, size.height), paint);
      canvas.drawLine(
          Offset(d + size.height, 0), Offset(d, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant final AtelierPatternPainter oldDelegate) =>
      oldDelegate.pattern != pattern ||
      oldDelegate.base != base ||
      oldDelegate.ink != ink ||
      oldDelegate.glow != glow;
}
