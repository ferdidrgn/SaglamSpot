import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_design_tokens.dart';

/// 2026 tasarım dilinin temel yapı taşı: katmanlı, buzlu-cam bir yüzey.
/// Arkasındaki içeriği [BackdropFilter] ile bulanıklaştırır, üzerine ince
/// bir kenarlık + üstte tek piksellik bir "specular highlight" çizgisi
/// ekler. [chromaticEdge] açıldığında köşelerde ince, iki renkli (soğuk/
/// sıcak) bir kromatik-sapma fringe'i belirir — bento-grid kartları ve öne
/// çıkan paneller için imza bir detay.
///
/// Tema-duyarlıdır: tüm renkler [AppGlassTokens] üzerinden gelir, bu yüzden
/// açık/koyu temada otomatik doğru tonu alır.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma,
    this.strong = false,
    this.chromaticEdge = false,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
    this.borderColor,
    this.borderWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? blurSigma;

  /// Varsayılan token kenarlığı yerine (ör. bir input'un odak durumunda)
  /// dinamik bir kenarlık rengi/kalınlığı vermek için.
  final Color? borderColor;
  final double? borderWidth;

  /// true ise daha opak/belirgin bir cam dolgusu kullanır (basılı/seçili
  /// durumlar, ya da düşük kontrastlı bir görsel üzerine binen kartlar için).
  final bool strong;

  /// Köşelere ince, iki tonlu bir kromatik-sapma çizgisi ekler.
  final bool chromaticEdge;

  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  Widget build(final BuildContext context) {
    final tokens = context.glass;
    final radius = borderRadius ?? tokens.radiusMd;
    final blur = blurSigma ?? tokens.blurMd;
    final radiusGeometry = BorderRadius.circular(radius);

    Widget surface = ClipRRect(
      borderRadius: radiusGeometry,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: alignment,
          decoration: BoxDecoration(
            color: strong ? tokens.glassTintStrong : tokens.glassTint,
            borderRadius: radiusGeometry,
            border: Border.all(
              color: borderColor ?? tokens.glassBorder,
              width: borderWidth ?? tokens.hairline,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: radiusGeometry,
            border: Border(
              top: BorderSide(color: tokens.glassHighlight, width: tokens.hairline),
            ),
          ),
          child: child,
        ),
      ),
    );

    if (chromaticEdge) {
      surface = CustomPaint(
        foregroundPainter: _ChromaticEdgePainter(
          radius: radius,
          colorA: tokens.chromaticA,
          colorB: tokens.chromaticB,
          strokeWidth: tokens.hairline,
        ),
        child: surface,
      );
    }

    surface = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radiusGeometry,
        boxShadow: [
          BoxShadow(color: tokens.shadowColor, blurRadius: 24, offset: const Offset(0, 12)),
          // Marka rengiyle tonlanmış "glow" — nötr bir gölge yerine kartın
          // altından ışıyan bir aksan bırakır, cam hissini güçlendirir.
          BoxShadow(color: tokens.glowColor, blurRadius: 40, spreadRadius: -6, offset: const Offset(0, 18)),
        ],
      ),
      child: surface,
    );

    if (onTap != null) {
      surface = Material(
        color: Colors.transparent,
        borderRadius: radiusGeometry,
        child: InkWell(
          borderRadius: radiusGeometry,
          onTap: onTap,
          child: surface,
        ),
      );
    }

    if (margin != null) surface = Padding(padding: margin!, child: surface);

    return surface;
  }
}

/// Köşelerde beliren ultra-ince, iki renkli kromatik-sapma çizgisi.
/// Gerçek bir lens fringe'ini taklit etmek için iki hafif ofsetli
/// rounded-rect stroke çizer — pahalı olmayan, tek seferlik bir paint.
class _ChromaticEdgePainter extends CustomPainter {
  const _ChromaticEdgePainter({
    required this.radius,
    required this.colorA,
    required this.colorB,
    required this.strokeWidth,
  });

  final double radius;
  final Color colorA;
  final Color colorB;
  final double strokeWidth;

  @override
  void paint(final Canvas canvas, final Size size) {
    final paintA = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorA.withOpacity(0.6);
    final paintB = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorB.withOpacity(0.6);

    final rrectA = RRect.fromRectAndRadius(
      Rect.fromLTWH(-0.5, -0.5, size.width + 1, size.height + 1),
      Radius.circular(radius),
    );
    final rrectB = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular((radius - 0.5).clamp(0.0, radius)),
    );

    canvas.drawRRect(rrectA, paintA);
    canvas.drawRRect(rrectB, paintB);
  }

  @override
  bool shouldRepaint(covariant final _ChromaticEdgePainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.colorA != colorA ||
      oldDelegate.colorB != colorB ||
      oldDelegate.strokeWidth != strokeWidth;
}
