import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/enum/enums.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../../features/products/presentation/providers/category_meta_provider.dart';

/// Discover ("Keşfet") ve Search sayfalarının paylaştığı kategori rayı —
/// aynı görsel dili iki farklı yönde çizer: dikey modda (Discover) 90°
/// döndürülmüş etiketler + sol kenarda vurgu çubuğu, yatay modda (Search)
/// düz metin + alt kenarda vurgu çubuğu. Seçili etiket koyu/kalın, diğerleri
/// soluk/ince — her iki modda da `orderedActiveCategoriesProvider`'dan
/// beslenir. Bu widget, önceden birbirine neredeyse birebir kopya olan
/// `_RotatedCategoryRail`/`_RailLabel` (discover_page.dart) ile
/// `_HorizontalCategoryRail`/`_HorizontalRailLabel` (search_page.dart)
/// sınıflarının birleştirilmiş halidir — görsel çıktı DEĞİŞMEDEN tek yerde
/// toplanmıştır.
class CategoryAccentRail extends ConsumerWidget {
  final Axis orientation;
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;

  /// "Tümü" etiketinin vurgu rengi (kategori rengi yerine kullanılır).
  final Color allColor;

  /// Seçili etiketin metin rengi.
  final Color selectedTextColor;

  /// Seçili olmayan etiketlerin metin rengi.
  final Color unselectedTextColor;

  /// Dış `ListView`'in padding'i (yön'e göre çağıran taraf belirler).
  final EdgeInsetsGeometry? padding;

  /// Dikey modda dış `Container`'ın sabit genişliği (örn. 56).
  final double? width;

  /// Dikey modda dış `Container`'ın kenarlığı (örn. sağda ince çizgi).
  final BoxBorder? border;

  /// Yatay modda dış `SizedBox`'ın sabit yüksekliği (örn. 42).
  final double? height;

  const CategoryAccentRail({
    super.key,
    required this.orientation,
    required this.selected,
    required this.onSelect,
    required this.allColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    this.padding,
    this.width,
    this.border,
    this.height,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    final labels = <Widget>[
      _CategoryAccentLabel(
        label: context.l10n.conditionAll,
        color: allColor,
        isSelected: selected == null,
        onTap: () => onSelect(null),
        orientation: orientation,
        selectedTextColor: selectedTextColor,
        unselectedTextColor: unselectedTextColor,
      ),
      for (final meta in categories)
        _CategoryAccentLabel(
          label: meta.customLabel ?? meta.category.label(context),
          color: meta.color,
          isSelected: selected == meta.category,
          onTap: () => onSelect(meta.category),
          orientation: orientation,
          selectedTextColor: selectedTextColor,
          unselectedTextColor: unselectedTextColor,
        ),
    ];

    final listView = ListView(
      scrollDirection: orientation,
      padding: padding,
      children: labels,
    );

    if (orientation == Axis.vertical) {
      return Container(
        width: width,
        decoration: border != null ? BoxDecoration(border: border) : null,
        child: listView,
      );
    }

    return SizedBox(height: height, child: listView);
  }
}

class _CategoryAccentLabel extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final Axis orientation;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const _CategoryAccentLabel({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.orientation,
    required this.selectedTextColor,
    required this.unselectedTextColor,
  });

  @override
  Widget build(final BuildContext context) {
    if (orientation == Axis.vertical) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: isSelected ? 22 : 0,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSelected ? 13 : 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? selectedTextColor : unselectedTextColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSelected ? 13.5 : 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? selectedTextColor : unselectedTextColor,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 22 : 0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
