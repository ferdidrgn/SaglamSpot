import 'package:flutter/material.dart';
import '../enum/enums.dart';
import 'app_context_ui_extension.dart';

extension ProductCategoryExtension on ProductCategory? {
  String label(final BuildContext context) {
    final l10n = context.l10n;
    if (this == null) return l10n.conditionAll;
    return switch (this!) {
      ProductCategory.sofa => l10n.categorySofa,
      ProductCategory.chair => l10n.categoryChair,
      ProductCategory.table => l10n.categoryTable,
      ProductCategory.bed => l10n.categoryBed,
      ProductCategory.wardrobe => l10n.categoryWardrobe,
      ProductCategory.white => l10n.categoryWhite,
      ProductCategory.other => l10n.categoryOther,
    };
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
