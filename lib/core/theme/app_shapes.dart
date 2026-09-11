import 'package:flutter/material.dart';

/// Uygulamanın TEK asimetrik köşe imzası — kartlarda (CustomProductCard),
/// galeri çerçevelerinde, panellerde tekrar eden aynı şekil dili. Tek
/// köşe keskin, karşı köşe belirgin yuvarlak; iki ara köşe küçük/nötr.
/// [radius] büyük (yuvarlak) köşenin yarıçapı, [small] keskin köşenin
/// yarıçapıdır.
class AppShapes {
  AppShapes._();

  static BorderRadius asymmetric(
          {final double radius = 28, final double small = 8}) =>
      BorderRadius.only(
        topLeft: Radius.circular(small),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(small),
      );

  /// Ayna görüntüsü — keskin köşe sağ üstte değil sol üstte.
  static BorderRadius asymmetricMirrored(
          {final double radius = 28, final double small = 8}) =>
      BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(small),
        bottomLeft: Radius.circular(small),
        bottomRight: Radius.circular(radius),
      );
}
