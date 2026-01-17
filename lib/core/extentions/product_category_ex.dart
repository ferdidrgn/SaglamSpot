import 'package:flutter/material.dart';
import '../enum/enums.dart';

extension ProductCategoryX on ProductCategory {
  /// Firebase / API için (ING)
  String get value => name;

  /// UI için locale bazlı isim
  String label(final BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    switch (this) {
      case ProductCategory.sofa:
        return locale == 'tr' ? 'Koltuklar' : 'Sofas';
      case ProductCategory.chair:
        return locale == 'tr' ? 'Sandalyeler' : 'Chairs';
      case ProductCategory.table:
        return locale == 'tr' ? 'Masalar' : 'Tables';
      case ProductCategory.bed:
        return locale == 'tr' ? 'Yatak Baza' : 'Beds';
      case ProductCategory.wardrobe:
        return locale == 'tr' ? 'Dolaplar' : 'Wardrobes';
      case ProductCategory.white:
        return locale == 'tr' ? 'Beyaz Eşyalar' : 'White Utensils';
      case ProductCategory.other:
        return locale == 'tr' ? 'Diğer' : 'Other';
    }
  }
}
