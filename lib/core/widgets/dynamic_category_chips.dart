import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/enum/enums.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
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

    // Çipler artık sayfa zemininde tek başına yüzmüyor — mobil uygulamadaki
    // segmented-control hissi için hepsini tek, yumuşak/soft bir "track"
    // bandının içine alıyoruz. Bant kendi hafif gölgesiyle tüm şeridi tek
    // bir UI elemanı gibi okutuyor.
    return Container(
      height: context.responsive(mobile: 60, tablet: 68, desktop: 76),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(26),
      ),
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
      scale: isSelected ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal:
                  context.responsive(mobile: 16, tablet: 18, desktop: 20),
              vertical: context.responsive(mobile: 10, tablet: 12, desktop: 14),
            ),
            decoration: BoxDecoration(
              // Gradyan yerine düz, tek renk seçili zemin — mobil uygulama
              // çiplerindeki gibi daha sade/soft bir dolgu hissi.
              color: isSelected ? color : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color:
                    isSelected ? Colors.transparent : color.withOpacity(0.16),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withOpacity(0.22)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: isSelected ? 14 : 6,
                  offset: const Offset(0, 5),
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
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
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
