import 'package:flutter/material.dart';

/// Ürün galerisinin üst köşeleri yuvarlak, alt kenarı ise akışkan bir
/// dalga şeklinde kesilmesini sağlayan clipper. Referans tasarımlardaki
/// (ekran görüntülerindeki) "dalgalanma" geçiş efektini üretir.
class WaveBottomClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double waveHeight;

  const WaveBottomClipper({this.cornerRadius = 28, this.waveHeight = 22});

  @override
  Path getClip(final Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height - waveHeight;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);
    path.lineTo(w, h - waveHeight * 0.3);

    // Akışkan dalga: iki kontrol noktalı yumuşak S eğrisi.
    path.cubicTo(
      w * 0.75, h + waveHeight,
      w * 0.55, h - waveHeight,
      w * 0.5, h,
    );
    path.cubicTo(
      w * 0.35, h + waveHeight,
      w * 0.15, h - waveHeight * 0.6,
      0, h - waveHeight * 0.1,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(final CustomClipper<Path> oldClipper) => false;
}
