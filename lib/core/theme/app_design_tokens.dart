import 'dart:ui';
import 'package:flutter/material.dart';

/// 2026 "Endüstriyel-Cam" tasarım dilinin ham token'ları — mevcut sıcak
/// kahve/amber marka paletini (bkz. [AppColors]) TERK ETMEZ, onun üzerine
/// ince kenarlıklar, katmanlı buzlu-cam yüzeyler ve kromatik-kenar aksanları
/// giydirir. Bir [ThemeExtension] olduğu için `Theme.of(context)
/// .extension<AppGlassTokens>()!` ile her yerden okunabilir ve tema
/// (açık/koyu) değiştiğinde otomatik olarak animasyonla geçiş yapar.
@immutable
class AppGlassTokens extends ThemeExtension<AppGlassTokens> {
  const AppGlassTokens({
    required this.blurSm,
    required this.blurMd,
    required this.blurLg,
    required this.hairline,
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.glassTint,
    required this.glassTintStrong,
    required this.glassBorder,
    required this.glassHighlight,
    required this.chromaticA,
    required this.chromaticB,
    required this.meshColors,
    required this.shadowColor,
    required this.noiseOpacity,
  });

  /// Küçük yüzeyler (çip, rozet) için hafif bulanıklık.
  final double blurSm;

  /// Kart/panel yüzeyleri için orta bulanıklık.
  final double blurMd;

  /// Tam ekran header/tab bar gibi büyük camlar için yoğun bulanıklık.
  final double blurLg;

  /// "0.5–1px" ultra-ince kenarlık genişliği.
  final double hairline;

  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;

  /// Cam yüzeyin temel dolgu rengi (düşük opaklıklı, brightness'a duyarlı).
  final Color glassTint;

  /// Daha belirgin/aktif cam yüzeyler için (basılı, seçili) güçlü ton.
  final Color glassTintStrong;

  /// İnce kenarlık rengi.
  final Color glassBorder;

  /// Camın üst kenarında beliren ince ışık çizgisi (specular highlight).
  final Color glassHighlight;

  /// Kromatik sapma aksanının soğuk (cyan/mavi) ucu.
  final Color chromaticA;

  /// Kromatik sapma aksanının sıcak (magenta/amber) ucu.
  final Color chromaticB;

  /// Ambiyans arka planındaki gradyan-mesh lekelerinin renkleri.
  final List<Color> meshColors;

  final Color shadowColor;

  /// Prosedürel gren/doku dokusunun opaklığı.
  final double noiseOpacity;

  static const AppGlassTokens light = AppGlassTokens(
    blurSm: 8,
    blurMd: 18,
    blurLg: 32,
    hairline: 0.75,
    radiusXs: 10,
    radiusSm: 16,
    radiusMd: 22,
    radiusLg: 28,
    radiusXl: 36,
    glassTint: Color(0x99FFFDF9),
    glassTintStrong: Color(0xCCFFFDF9),
    glassBorder: Color(0x333E2F23),
    glassHighlight: Color(0x66FFFFFF),
    chromaticA: Color(0xFF6FB8C9),
    chromaticB: Color(0xFFE0B074),
    meshColors: [
      Color(0x33E8B573),
      Color(0x266FB8C9),
      Color(0x22A9714B),
    ],
    shadowColor: Color(0x1F2A1F17),
    noiseOpacity: 0.02,
  );

  static const AppGlassTokens dark = AppGlassTokens(
    blurSm: 8,
    blurMd: 20,
    blurLg: 36,
    hairline: 0.75,
    radiusXs: 10,
    radiusSm: 16,
    radiusMd: 22,
    radiusLg: 28,
    radiusXl: 36,
    glassTint: Color(0x662A1F17),
    glassTintStrong: Color(0x99241A13),
    glassBorder: Color(0x40F0D4A8),
    glassHighlight: Color(0x33FFFFFF),
    chromaticA: Color(0xFF7FD8E8),
    chromaticB: Color(0xFFF0D4A8),
    meshColors: [
      Color(0x40E8B573),
      Color(0x337FD8E8),
      Color(0x2AC79868),
    ],
    shadowColor: Color(0x66000000),
    noiseOpacity: 0.035,
  );

  @override
  AppGlassTokens copyWith({
    final double? blurSm,
    final double? blurMd,
    final double? blurLg,
    final double? hairline,
    final double? radiusXs,
    final double? radiusSm,
    final double? radiusMd,
    final double? radiusLg,
    final double? radiusXl,
    final Color? glassTint,
    final Color? glassTintStrong,
    final Color? glassBorder,
    final Color? glassHighlight,
    final Color? chromaticA,
    final Color? chromaticB,
    final List<Color>? meshColors,
    final Color? shadowColor,
    final double? noiseOpacity,
  }) =>
      AppGlassTokens(
        blurSm: blurSm ?? this.blurSm,
        blurMd: blurMd ?? this.blurMd,
        blurLg: blurLg ?? this.blurLg,
        hairline: hairline ?? this.hairline,
        radiusXs: radiusXs ?? this.radiusXs,
        radiusSm: radiusSm ?? this.radiusSm,
        radiusMd: radiusMd ?? this.radiusMd,
        radiusLg: radiusLg ?? this.radiusLg,
        radiusXl: radiusXl ?? this.radiusXl,
        glassTint: glassTint ?? this.glassTint,
        glassTintStrong: glassTintStrong ?? this.glassTintStrong,
        glassBorder: glassBorder ?? this.glassBorder,
        glassHighlight: glassHighlight ?? this.glassHighlight,
        chromaticA: chromaticA ?? this.chromaticA,
        chromaticB: chromaticB ?? this.chromaticB,
        meshColors: meshColors ?? this.meshColors,
        shadowColor: shadowColor ?? this.shadowColor,
        noiseOpacity: noiseOpacity ?? this.noiseOpacity,
      );

  @override
  AppGlassTokens lerp(final ThemeExtension<AppGlassTokens>? other, final double t) {
    if (other is! AppGlassTokens) return this;
    return AppGlassTokens(
      blurSm: lerpDouble(blurSm, other.blurSm, t)!,
      blurMd: lerpDouble(blurMd, other.blurMd, t)!,
      blurLg: lerpDouble(blurLg, other.blurLg, t)!,
      hairline: lerpDouble(hairline, other.hairline, t)!,
      radiusXs: lerpDouble(radiusXs, other.radiusXs, t)!,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      radiusXl: lerpDouble(radiusXl, other.radiusXl, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      glassTintStrong: Color.lerp(glassTintStrong, other.glassTintStrong, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassHighlight: Color.lerp(glassHighlight, other.glassHighlight, t)!,
      chromaticA: Color.lerp(chromaticA, other.chromaticA, t)!,
      chromaticB: Color.lerp(chromaticB, other.chromaticB, t)!,
      meshColors: [
        for (int i = 0; i < meshColors.length; i++)
          Color.lerp(meshColors[i], other.meshColors[i], t)!,
      ],
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      noiseOpacity: lerpDouble(noiseOpacity, other.noiseOpacity, t)!,
    );
  }
}

extension AppGlassTokensContext on BuildContext {
  AppGlassTokens get glass =>
      Theme.of(this).extension<AppGlassTokens>() ?? AppGlassTokens.light;
}
