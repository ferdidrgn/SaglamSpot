import 'package:flutter/material.dart';
import '../enum/enums.dart';
import 'app_context_ui_extension.dart';

extension ProductCategoryExtension on ProductCategory? {
  String label(final BuildContext context) {
    if (this == null) return context.l10n.conditionAll;
    final label = switch (this!) {
      ProductCategory.sofa => context.l10n.categorySofa,
      ProductCategory.chair => context.l10n.categoryChair,
      ProductCategory.table => context.l10n.categoryTable,
      ProductCategory.bed => context.l10n.categoryBed,
      ProductCategory.wardrobe => context.l10n.categoryWardrobe,
      ProductCategory.white => context.l10n.categoryWhite,
      ProductCategory.other => context.l10n.categoryOther
    };
    return label; // Eğer l10n anahtarı null ise boş string dön
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
