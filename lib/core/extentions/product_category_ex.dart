import 'package:flutter/material.dart';
import '../enum/enums.dart';

/// =======================
/// CATEGORY METADATA
/// =======================
extension ProductCategoryMeta on ProductCategory {
  /// Firestore + Search key
  String get key => name;

  /// Arama için sabit kelimeler (dil bağımsız)
  List<String> get searchKeywords {
    switch (this) {
      case ProductCategory.sofa:
        return ['sofa', 'koltuk'];
      case ProductCategory.chair:
        return ['chair', 'sandalye'];
      case ProductCategory.table:
        return ['table', 'masa'];
      case ProductCategory.bed:
        return ['bed', 'yatak'];
      case ProductCategory.wardrobe:
        return ['wardrobe', 'dolap'];
      case ProductCategory.white:
        return ['white appliances', 'beyaz eşya'];
      case ProductCategory.other:
        return ['other', 'diğer'];
    }
  }

  /// UI label (Localization-aware)
  String label(final BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    switch (this) {
      case ProductCategory.sofa:
        return lang == 'tr' ? 'Koltuk / Kanepe' : 'Sofa';
      case ProductCategory.chair:
        return lang == 'tr' ? 'Sandalye / Tabure' : 'Chair';
      case ProductCategory.table:
        return lang == 'tr' ? 'Masa' : 'Table';
      case ProductCategory.bed:
        return lang == 'tr' ? 'Yatak / Baza' : 'Bed';
      case ProductCategory.wardrobe:
        return lang == 'tr' ? 'Dolap' : 'Wardrobe';
      case ProductCategory.white:
        return lang == 'tr' ? 'Beyaz Eşya' : 'White Appliances';
      case ProductCategory.other:
        return lang == 'tr' ? 'Diğer' : 'Other';
    }
  }
}

extension ProductCategoryMapper on String {
  ProductCategory toProductCategory() {
    try {
      return ProductCategory.values.byName(this);
    } catch (_) {
      return ProductCategory.other;
    }
  }
}

extension ProductCategoryToString on ProductCategory {
  String toFirestore() => name;
}
