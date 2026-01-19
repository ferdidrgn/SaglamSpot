import 'package:flutter/material.dart';
import '../extentions/app_context_ui_extension.dart';

enum AppLanguage { tr, en }

enum ProductCategory { sofa, chair, table, bed, wardrobe, white, other }

enum ProductCondition {
  all,
  newProduct,
  used;

  // ARB dosyasındaki karşılıklarını getiren extension mantığı
  String label(final BuildContext context) {
    switch (this) {
      case ProductCondition.all:
        return context.l10n.conditionAll;
      case ProductCondition.newProduct:
        return context.l10n.conditionNew;
      case ProductCondition.used:
        return context.l10n.conditionUsed;
    }
  }
}

enum AdUnitType {
  banner, // Mobil Banner
  native, // Mobil Native
  display, // Web Görüntülü
  inArticle, // Web Yazı İçi
  multiplex, // Web Benzer Ürünler Altı
}
