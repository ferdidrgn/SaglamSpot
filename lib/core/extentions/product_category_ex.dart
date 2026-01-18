import 'package:flutter/material.dart';
import '../enum/enums.dart';
import 'app_context_ui_extension.dart';

extension ProductCategoryExtension on ProductCategory {
  String label(final BuildContext context) {
    switch (this) {
      case ProductCategory.sofa:
        return context.l10n.categorySofa;
      case ProductCategory.chair:
        return context.l10n.categoryChair;
      case ProductCategory.table:
        return context.l10n.categoryTable;
      case ProductCategory.bed:
        return context.l10n.categoryBed;
      case ProductCategory.wardrobe:
        return context.l10n.categoryWardrobe;
      case ProductCategory.white:
        return context.l10n.categoryWhite;
      case ProductCategory.other:
        return context.l10n.categoryOther;
    }
  }
}

extension ProductCategoryMapper on String {
  // byName yerine firstWhere kullanmak, küçük/büyük harf veya eksik veri hatalarında
  // uygulamanın çökmesini engeller ve 'other' döndürür.
  ProductCategory toProductCategory() =>
      ProductCategory.values.firstWhere((final e) => e.name == this,
          orElse: () => ProductCategory.other);
}

// Firestore'a her zaman Enum'un kod adını (sofa, chair vb.) gönderir.
extension ProductCategoryToString on ProductCategory {
  String toFirestore() => name;
}
