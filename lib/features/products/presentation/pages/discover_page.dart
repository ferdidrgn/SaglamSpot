import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_product_grid.dart';
import '../../../../core/widgets/cart_icon_button.dart';
import '../../../../core/widgets/whatsapp_quick_fab.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../data/models/category_meta.dart';
import '../../domain/entites/product.dart';
import '../providers/category_meta_provider.dart';
import '../providers/product_filters_provider.dart';

/// Mobil-öncelikli "Keşfet" ekranı — eskiden ayrı sekmeler olan Sıfır ve
/// Spot koleksiyonlarını tek bir yerde, üstteki segment kontrolüyle
/// birleştirir (native app'lerde alışılmış "kategori sekmeleri" hissi).
/// Web tarafı bu ekranı KULLANMAZ — orada /new ve /spot hâlâ bağımsız,
/// SEO'lu üst-nav sekmeleridir (bkz. NewProductsPage/SpotProductsPage).
class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key, this.initialSpot = false});

  /// true ise sayfa doğrudan "Spot" segmentiyle açılır (bkz.
  /// NavigationHandler.goToDiscover, ana sayfadaki vitrin kapılarından).
  final bool initialSpot;

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  late bool _isSpot = widget.initialSpot;
  ProductCategory? _selectedCategory;

  @override
  Widget build(final BuildContext context) {
    final List<Product> source = _isSpot
        ? ref.watch(spotDealsProductsProvider)
        : ref.watch(newDealsProductsProvider);

    final List<Product> filtered = _selectedCategory == null
        ? source
        : source.where((final p) => p.category == _selectedCategory).toList();

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.navDiscover,
          style: TextStyle(
            color: AppColors.mobileTextPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => NavigationHandler.goToSearch(context),
            icon: Icon(Icons.search_rounded, color: AppColors.mobileTextPrimary),
          ),
          const CartIconButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: Row(
        children: [
          // Referans tasarımdaki "yan dönük" kategori rayı — yatay çip
          // şeridi yerine, sol kenara sabitlenmiş, döndürülmüş metinli
          // dikey bir kategori navigasyonu. Kategori sayısı artık 13'e
          // çıktığı için (bkz. ProductCategory) kaydırılabilir.
          _RotatedCategoryRail(
            selected: _selectedCategory,
            onSelect: (final c) => setState(() => _selectedCategory = c),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 16, 12),
                  child: _ConditionSegment(
                    isSpot: _isSpot,
                    onChanged: (final value) {
                      HapticFeedback.selectionClick();
                      setState(() => _isSpot = value);
                    },
                  ),
                ),
                Expanded(
                  child: ResponsiveProductGrid(products: filtered),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      floatingActionButton: !kIsWeb ? const WhatsAppQuickFab() : null,
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }
}

/// "Sıfır / Spot" segment kontrolü — DynamicCategoryChips'in altındaki
/// çip diliyle karışmasın diye bilinçli olarak tek parça, dolgulu bir
/// "pill" anahtarı: iki büyük seçenek arasında tam ekran genişliğinde
/// gezinmenin native app'lerde alışılmış hissi.
class _ConditionSegment extends StatelessWidget {
  final bool isSpot;
  final ValueChanged<bool> onChanged;

  const _ConditionSegment({required this.isSpot, required this.onChanged});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.mobileSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: context.l10n.conditionNew,
              isActive: !isSpot,
              activeColor: AppColors.success,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: context.l10n.conditionUsed,
              isActive: isSpot,
              activeColor: AppColors.mobileAccentDark,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

/// Referans görseldeki "yan dönük yazılar" kategori rayı — her kategori
/// etiketi 90° döndürülmüş, dikey bir şerit halinde alt alta dizilir
/// (aşağıdan yukarı okunur, tıpkı bir kitap sırtı gibi). Seçili olan koyu/
/// kalın, diğerleri soluk — küçük bir vurgu çizgisiyle işaretlenir. 13
/// kategori ekrana sığmayabileceği için dikey kaydırılabilir.
class _RotatedCategoryRail extends ConsumerWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;

  const _RotatedCategoryRail({required this.selected, required this.onSelect});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return Container(
      width: 56,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.mobileBorder)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _RailLabel(
            label: context.l10n.conditionAll,
            color: AppColors.mobilePrimary,
            isSelected: selected == null,
            onTap: () => onSelect(null),
          ),
          for (final CategoryMeta meta in categories)
            _RailLabel(
              label: meta.customLabel ?? meta.category.label(context),
              color: meta.color,
              isSelected: selected == meta.category,
              onTap: () => onSelect(meta.category),
            ),
        ],
      ),
    );
  }
}

class _RailLabel extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailLabel({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) => InkWell(
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
                    color: isSelected
                        ? AppColors.mobileTextPrimary
                        : AppColors.mobileTextTertiary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.mobileTextSecondary,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
