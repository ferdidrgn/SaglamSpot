import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/enum/enums.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../util/responsive_utils.dart';
import '../../features/products/data/models/category_meta.dart';
import '../../features/products/presentation/providers/category_meta_provider.dart';

/// Firebase 'CategoryMeta' koleksiyonundan beslenen, canlı renkli, gölgeli,
/// Material 3 hissiyatında kategori chip şeridi. Hem ana sayfada hem arama/
/// filtreleme sayfasında aynı görsel dile sahip olmak için ortak kullanılır.
class DynamicCategoryChips extends ConsumerWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;
  final EdgeInsets? padding;

  const DynamicCategoryChips({
    super.key,
    required this.selected,
    required this.onSelect,
    this.padding,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: context.responsive(mobile: 56, tablet: 64, desktop: 72),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ??
            EdgeInsets.symmetric(
                horizontal:
                    context.responsive(mobile: 16, tablet: 28, desktop: 40)),
        itemCount: categories.length + 1, // +1 = "Tümü" çipi
        separatorBuilder: (final _, final __) => const SizedBox(width: 10),
        itemBuilder: (final context, final index) {
          if (index == 0) {
            return _CategoryChip(
              label: context.l10n.conditionAll,
              icon: Icons.grid_view_rounded,
              color: context.primaryColor,
              isSelected: selected == null,
              onTap: () => onSelect(null),
            );
          }

          final meta = categories[index - 1];
          final label = meta.customLabel ?? meta.category.label(context);

          return _CategoryChip(
            label: label,
            icon: meta.icon,
            color: meta.color,
            isSelected: selected == meta.category,
            onTap: () => onSelect(meta.category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal:
                  context.responsive(mobile: 16, tablet: 18, desktop: 20),
              vertical: context.responsive(mobile: 10, tablet: 12, desktop: 14),
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [color, color.withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : color.withOpacity(0.25),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withOpacity(0.35)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: context.responsive(mobile: 16, tablet: 18, desktop: 20),
                  color: isSelected ? Colors.white : color,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize:
                        context.responsive(mobile: 13, tablet: 13.5, desktop: 14),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : context.primaryColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
