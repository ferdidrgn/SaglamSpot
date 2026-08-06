import 'package:flutter/material.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_meta.dart';

/// Ürün ekleme/düzenleme formlarında kullanılan, tek seçimli kategori
/// seçici. Ana sayfadaki/arama sayfasındaki dinamik chip sistemiyle aynı
/// ikon+renk paletini kullanır — tutarlı bir görsel dil sağlar.
class CategoryFormSelector extends StatelessWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory> onSelect;

  const CategoryFormSelector(
      {super.key, required this.selected, required this.onSelect});

  @override
  Widget build(final BuildContext context) {
    final metas = defaultCategoryMeta.values.toList()
      ..sort((final a, final b) => a.order.compareTo(b.order));

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: metas.map((final meta) {
        final isSelected = selected == meta.category;
        return GestureDetector(
          onTap: () => onSelect(meta.category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? meta.color : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? meta.color : AppColors.border,
                width: 1.4,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: meta.color.withOpacity(0.3), blurRadius: 10)]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(meta.icon,
                    size: 16, color: isSelected ? Colors.white : meta.color),
                const SizedBox(width: 6),
                Text(
                  meta.category.label(context),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
