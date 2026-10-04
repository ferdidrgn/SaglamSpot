import 'package:flutter/material.dart';

/// "Atölye" tasarım sisteminin ham ölçü token'ları. Yeni/değiştirilen her
/// mobil widget'ta ham sayı yerine bunlar kullanılır (bkz.
/// `.claude/skills/saglamspot-design/SKILL.md`). Renkler BURADA DEĞİL —
/// renk her zaman [AppColors] getter'larından gelir.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  /// Mobil ekran kenar boşluğu (Keşfet ile aynı ritim).
  static const double screen = 16;

  /// Bölümler arası dikey ritim.
  static const double section = 28;
}

abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;

  /// Uygulamanın imza köşesi — ürün kartındaki (custom_product_card.dart)
  /// keskin/yuvarlak zıtlığın küçük ölçekli hali. Yalnızca bir-iki vurgu
  /// noktasında (ekran başlığı rozeti, öne çıkan panel) kullanılır, her
  /// yerde değil.
  static const BorderRadius asymSm = BorderRadius.only(
    topLeft: Radius.circular(6),
    topRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(6),
  );

  static const BorderRadius asymLg = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(34),
    bottomLeft: Radius.circular(34),
    bottomRight: Radius.circular(8),
  );

  static BorderRadius all(final double r) => BorderRadius.circular(r);
}

abstract final class AppMotion {
  /// Basma geri bildirimi, çip/segment seçimi.
  static const Duration fast = Duration(milliseconds: 150);

  /// Panel/kart durum değişimi, sayfa içi geçişler.
  static const Duration normal = Duration(milliseconds: 220);

  /// Sheet/dialog, tek seferlik giriş.
  static const Duration slow = Duration(milliseconds: 320);

  /// Giriş/çıkış — güçlü ease-out (bkz. flutter-motion skill).
  static const Curve standard = Cubic(0.23, 1, 0.32, 1);

  /// Ekranda yer değiştirme.
  static const Curve move = Curves.easeInOutCubic;

  /// Liste girişlerinde öğe başına kademelendirme.
  static const Duration stagger = Duration(milliseconds: 40);
}

/// Derinlik hiyerarşisi: level0 düz → level4 yüzen. Her seviye tek bir
/// gölge katmanı döner (üst üste çok gölge = pahalı ve bulanık görünüm).
abstract final class AppShadows {
  static List<BoxShadow> level0(final Color tint) => const [];

  static List<BoxShadow> level1(final Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> level2(final Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> level3(final Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> level4(final Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.18),
          blurRadius: 32,
          offset: const Offset(0, 14),
        ),
      ];
}
