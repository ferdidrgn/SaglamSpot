import 'package:flutter/material.dart';
import '../enum/enums.dart';

/// Spot ürün kartlarındaki "durum rozeti" için görsel karşılıklar — sahte
/// bir yıldız puanı yerine, esnafın kendi elle girdiği dürüst bir bilgi.
extension ProductWearTierExtension on ProductWearTier {
  String get label => switch (this) {
        ProductWearTier.likeNew => 'Az Kullanılmış',
        ProductWearTier.good => 'İyi Durumda',
        ProductWearTier.wellLoved => 'Kullanılmış, Sağlam',
      };

  IconData get icon => switch (this) {
        ProductWearTier.likeNew => Icons.new_releases_outlined,
        ProductWearTier.good => Icons.thumb_up_outlined,
        ProductWearTier.wellLoved => Icons.build_outlined,
      };

  Color get color => switch (this) {
        ProductWearTier.likeNew => const Color(0xFF2E7D32),
        ProductWearTier.good => const Color(0xFFE65100),
        ProductWearTier.wellLoved => const Color(0xFF6D4C41),
      };
}

extension ProductWearTierMapper on String? {
  /// Bilinmeyen/boş değer için null döner — sahte bir varsayılan UYDURMAZ.
  ProductWearTier? toProductWearTier() {
    if (this == null || this!.isEmpty) return null;
    for (final tier in ProductWearTier.values) {
      if (tier.name == this) return tier;
    }
    return null;
  }
}

extension ProductWearTierToString on ProductWearTier? {
  String? toFirestore() => this?.name;
}
