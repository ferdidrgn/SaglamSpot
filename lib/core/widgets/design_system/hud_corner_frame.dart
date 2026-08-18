import 'package:flutter/material.dart';
import '../../theme/app_design_tokens.dart';

/// Endüstriyel/HUD estetiğinin imza detayı: bir yüzeyin dört köşesine
/// yerleştirilen "L" biçimli köşe-braketleri (kamera vizörü / teknik çizim
/// köşe işaretleri gibi). Herhangi bir [child]'ı sarmalar, layout'a
/// dokunmaz — sadece üstüne ince braketler çizer.
class HudCornerFrame extends StatelessWidget {
  const HudCornerFrame({
    super.key,
    required this.child,
    this.armLength = 22,
    this.inset = 14,
    this.color,
    this.strokeWidth,
  });

  final Widget child;
  final double armLength;
  final double inset;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(final BuildContext context) {
    final tokens = context.glass;
    return CustomPaint(
      foregroundPainter: _HudCornerPainter(
        color: color ?? tokens.chromaticB,
        armLength: armLength,
        inset: inset,
        strokeWidth: strokeWidth ?? (tokens.hairline * 1.6),
      ),
      child: child,
    );
  }
}

class _HudCornerPainter extends CustomPainter {
  const _HudCornerPainter({
    required this.color,
    required this.armLength,
    required this.inset,
    required this.strokeWidth,
  });

  final Color color;
  final double armLength;
  final double inset;
  final double strokeWidth;

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final left = inset;
    final top = inset;
    final right = size.width - inset;
    final bottom = size.height - inset;

    // Sol üst
    canvas
      ..drawLine(Offset(left, top), Offset(left + armLength, top), paint)
      ..drawLine(Offset(left, top), Offset(left, top + armLength), paint)
      // Sağ üst
      ..drawLine(Offset(right, top), Offset(right - armLength, top), paint)
      ..drawLine(Offset(right, top), Offset(right, top + armLength), paint)
      // Sol alt
      ..drawLine(Offset(left, bottom), Offset(left + armLength, bottom), paint)
      ..drawLine(Offset(left, bottom), Offset(left, bottom - armLength), paint)
      // Sağ alt
      ..drawLine(Offset(right, bottom), Offset(right - armLength, bottom), paint)
      ..drawLine(Offset(right, bottom), Offset(right, bottom - armLength), paint);
  }

  @override
  bool shouldRepaint(covariant final _HudCornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.armLength != armLength ||
      oldDelegate.inset != inset ||
      oldDelegate.strokeWidth != strokeWidth;
}
